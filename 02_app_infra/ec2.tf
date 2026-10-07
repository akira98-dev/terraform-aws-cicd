resource "aws_instance" "web_server" {
  # OSのイメージIDを指定
  ami = "ami-0d52744d6551d851e" # ※時期によって変わる
  # サーバーのスペック（小規模・演習用の定番）
  instance_type = "t3.micro"
  # 配置するサブネットのID
  subnet_id = aws_subnet.public_subnet_1a.id
  # 装着するセキュリティグループのID
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  # パブリックIPを付与
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