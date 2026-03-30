resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}
#calling from local.tf