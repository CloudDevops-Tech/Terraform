terraform {
  backend "s3" {
    bucket = "backendremotes3bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}