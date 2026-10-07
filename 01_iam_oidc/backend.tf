terraform {
  backend "s3" {
    bucket  = "my-terraform-tfstate-akira"
    key     = "01_iam_oidc/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}