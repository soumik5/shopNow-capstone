terraform {
  backend "s3" {
    bucket       = "shopnow-terraform-state-unique-123456"
    key          = "shopnow/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}