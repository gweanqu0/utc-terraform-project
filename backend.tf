terraform {
  backend "s3" {
    bucket = "week7-terraform-bucket"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}