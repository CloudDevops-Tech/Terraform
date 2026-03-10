provider "aws" {
   region ="ap-south-1"
    profile ="default"
  }

    provider "aws" {
    region ="ap-south-2"
    alias = "test_env"
    profile ="test"
  }

  provider "aws" {
    region ="us-west-2"
    alias = "Prod_env"
    profile ="Prod"
  }