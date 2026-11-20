terraform {
  backend "s3" {
    bucket       = "shopnow-terraform-state-unique-123456"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}