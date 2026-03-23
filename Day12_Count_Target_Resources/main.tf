variable "dev" {
    type = bool
    default = true
}

resource "aws_instance" "name" {
   ami ="ami-0f559c3642608c138"
   instance_type = "t3.micro"
   count = var.dev ? 1 : 0
}
#if dev is true then create 1 instance if false then create 0 instance
