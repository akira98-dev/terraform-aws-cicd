# AWSのリージョン
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-northeast-1" #東京リージョン
}