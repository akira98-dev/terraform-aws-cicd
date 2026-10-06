terraform {
  backend "s3" {
    bucket  = "my-terraform-tfstate-akira"
    key     = "dev/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}