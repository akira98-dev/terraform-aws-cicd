# 作成されたVPCのIDを出力
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

# パブリックサブネット（1a / 1c）のIDを出力
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [
    aws_subnet.public_subnet_1a.id
  ]
}

# NAT GatewayのパブリックIPアドレスを出力
output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}
output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}