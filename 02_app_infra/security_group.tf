resource "aws_security_group" "web_sg" {
  name        = "${var.env_prefix}-web-sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id # どのVPCに作るか

  # インバウンドルール(入ってくる通信):HTTP(ポート80)
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # アウトバウンドルール(出ていく通信)すべて許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" は「すべてのプロトコル」という意味
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-web-sg"
  }
}