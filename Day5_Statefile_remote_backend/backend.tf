terraform {
  backend "s3" {
    bucket = "statefilebackends3bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}