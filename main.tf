terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region # 変数を参照
}

resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr # 変数を参照
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env_prefix}-vpc" # 変数を参照&{}内部が変数
  }
}
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs # 変数を参照
  availability_zone       = var.availability_zone   # 変数を参照
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet-1a" # 変数を参照
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env_prefix}-public-rt" # 変数を参照
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.env_prefix}-nat-eip" # 変数を参照
  }
}
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "${var.env_prefix}-nat-gw" # 変数を参照
  }

}
resource "aws_s3_bucket" "main" {
  bucket = "${var.env_prefix}-app-logs-20260920"
  
  tags = {
    Name = "${var.env_prefix}-app-logs-20260920"
  }
}

resource "aws_security_group" "web_sg" {
    name = "${var.env_prefix}-web-sg"
    description = "Allow http inbound traffic"
    vpc_id = aws_vpc.main.id # どのVPCに作るか

    # インバウンドルール(入ってくる通信):HTTP(ポート80)
    ingress {
        description = "Allow HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
            }
    # アウトバウンドルール(出ていく通信)すべて許可
    egress {
        from_port = 0
        to_port =  0
        protocol = "-1" # "-1" は「すべてのプロトコル」という意味
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-web-sg"
    }
}
resource "aws_instance" "web_server" {
    # OSのイメージIDを指定
    ami = "ami-0d52744d6551d851e" # ※時期によって変わるけど演習用ならこれでOKだにゃ
    # サーバーのスペック（小規模・演習用の定番）
    instance_type = "t3.micro"
    # 配置するサブネットのID
    subnet_id = aws_subnet.public_subnet_1a.id
    # 装着するセキュリティグループのID
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    # プライベートに置くためパブリックIP付与は不要
    associate_public_ip_address = true
    # 起動時に自動実行するスクリプト（Apacheインストール＆Web起動用）※オプション
        user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF
    # タグ
    tags = {
      Name = "${var.env_prefix}-web-server"
    }
}
