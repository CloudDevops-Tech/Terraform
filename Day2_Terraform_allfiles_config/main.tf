resource "aws_instance" "name" {
        ami = var.ami_id                           /*created ami_id in variables.tf*/
        instance_type = var.instance_type         /*created instance_type in variables.tf*/
        tags = {
          Name = "dev-Instance"
        }
  }