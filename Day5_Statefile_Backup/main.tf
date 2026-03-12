resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev"
    }
  
}

resource "aws_instance" "name" {
    ami = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
    tags = {
        Name = "test-instance"
    }   
  
}