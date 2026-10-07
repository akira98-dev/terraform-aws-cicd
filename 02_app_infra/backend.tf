terraform {
  backend "s3" {
    bucket  = "my-terraform-tfstate-akira"
    key     = "02_app_infra/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}