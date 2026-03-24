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
variable "env" {
    description = "environment name"
    default =[ "dev","test","prod" ]
    type = list(string)
}

resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    for_each = toset(var.env) 

#toset() is used to convert list into unique key-based collection so for_each can safely create resources.
#for_each cannot directly use a list of strings safely because:
#Lists are index-based.
#for_each needs unique keys.
#for_each = toset(var.env) Converts: ["dev", "prod"] Into a set:{"dev", "prod"}
tags = {
        Name = each.key  #so here we are creating 3 instances with different name
}
}
