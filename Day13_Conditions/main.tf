#Condition1: Region Validation 
variable "aws_region" {
description = "The region in which to create the infrastructure"
type        = string
nullable    = false
default     = "ap-south-1" 
#here we need to define either ap-south-1 or ap-south-2if i give other region will get error 
validation {
condition = var.aws_region == "ap-south-1" || var.aws_region == "ap-south-2"
error_message = "The variable 'aws_region' must be one of the following regions: ap-south-1,ap-south-2"
}
}
provider "aws" {
region = var.aws_region
}
resource "aws_s3_bucket" "dev" {
     bucket = "myregions3bucket1"
}

#condition2 :Conditional Resource Creation
variable "create_bucket" {
type    = bool
default = false
}
resource "aws_s3_bucket" "example" {
count  = var.create_bucket ? 1 : 0
bucket = "myconditionals3bucket"
}
#count = var.create_bucket ? 1 : 0
#true	1 - s3 Created
#false	0 - s3 Not created

#condition3 : Environment-based Instances
variable "environment" {
  type    = string
  default = "prod"
}
resource "aws_instance" "example" {
  count = var.environment == "prod" ? 3 : 1
    ami = "ami-0f559c3642608c138"
    instance_type = "t3.micro"

  tags = {
    Name = "example-${count.index}"
  }
}
#environment = "prod"
#Count.index=0 then example-0 Instance, Count.index=1 then example-1 Instance, Count.index=2 then example-2 Instance means 3 EC2 instances are created.

#environment = "dev" (or anything else)
#Count.index=0 then example-0 Instance means Only 1 EC2 instance created. 



