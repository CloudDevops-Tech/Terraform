resource "aws_instance" "dev" {
          ami= var.ami_id
          instance_type = var.instance_type
          tags = {
          Name = "dev-Instance"
            }
  }

  resource "aws_instance" "test" {
        ami = var.test_ami_id                          
        instance_type = var.test_instance_type
        provider = aws.test_env         
        tags = {
          Name = "test-Instance"
        }
  }

    resource "aws_instance" "Prod" {
        ami = var.Prod_ami_id                           
        instance_type = var.Prod_instance_type
        provider = aws.Prod_env         
        tags = {
          Name = "Prod-Instance"
        }
  }