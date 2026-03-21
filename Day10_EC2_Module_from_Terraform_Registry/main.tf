module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"    #source is terraform registry
  name = "single-instance"
  instance_type = "t3.micro"
  subnet_id     = "subnet-071e8f840cf0bb092"            #my default subnetid

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

/*These are input variables defined inside the module.
input variables defined inside the module as 
variable "instance_type" {
description = "EC2 instance type"
type        = string
}
internally, this module contains Terraform resources.
Inside the module, there will be a main.tf file.
That file contains actual AWS resources like
eg:aws_instance resource
resource "aws_instance" "this" {
  instance_type = "t3.micro"
  subnet_id     = "subnet-071e8f840cf0bb092"
  tags = {
    Name = "single-instance"
    Terraform = "true"
    Environment = "dev"
  }
}
*/