# AWSのリージョン
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-northeast-1" #東京リージョン
}
# VPCのCidr Bloc
variable "aws_vpc_cidr" {
  description = "cidr block for vpc"
  type        = string
  default     = "10.3.0.0/16"
}
#作業プレフィックス
variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
  default     = "stg"
}
# AZのリスト(1a)
variable "availability_zone" {
  description = "list og availability sones"
  type        = string
  default     = "ap-northeast-1a"
}
# パブリックサブネットCIDRのリスト1a用
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = string
  default     = "10.3.1.0/24"
}
