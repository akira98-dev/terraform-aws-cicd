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
  bucket = "${var.env_prefix}-app-logs-20261006"

  tags = {
    Name = "${var.env_prefix}-app-logs-20261006"
  }
}