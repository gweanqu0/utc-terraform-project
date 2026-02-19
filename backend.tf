terraform {
  backend "s3" {
    bucket = "multi-azs-terraform"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}