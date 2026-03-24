#use case-1 Same names for each instance
variable "ami_id" {
    description = "passing values to ami_id"
    default = ""
    type = string 
}

variable "instance_type" {
    description = "passing values to instance_type"
    default = ""
    type = string
}

resource "aws_instance" "dev" {
ami = var.ami_id
instance_type = var.instance_type
count = 2
     tags = {
       Name = "dev-instance"  
#so here we are creating 2 instances with same name
#dev-instance - count.index=0
#dev-instance - count.index=1
#count = 2 → Terraform creates 2 copies and uses count.index (0,1) to differentiate them.
 }
}


#use case-2 Different names for each instance using ${count.index}
variable "ami_id" {
    description = "passing values to ami_id"
    default = ""
    type = string 
}

variable "instance_type" {
    description = "passing values to instance_type"
    default = ""
    type = string
}

resource "aws_instance" "dev" {
ami = var.ami_id
instance_type = var.instance_type
count = 2
   tags = {
         Name = "dev-instance-${count.index}"  
#so here we are creating 2 instances with different name
#dev-instance-0 - count.index=0
#dev-instance-1 - count.index=1
 }
}

#use case-3 different names for each instance using type=list(string)
variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "env" {
  description = "environment name"
  type        = list(string)
  default     = ["dev", "test", "prod"]
}

  resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    count = length(var.env)
     tags = {
        Name = var.env[count.index]  
#so here we are creating 3 instances with different name
#length(var.env) → 3
#count = 3 → creates 3 instances
#var.env[count.index] → picks values:0 → dev, 1 → test, 2 → prod
     }
}

#while removing test server from this list prod deleted test renamed as a prod this is not recommanded.
#test instance → replaced by prod.
#original prod → destroyed.
#so we prefer for_each for creating servers and count for only condition

