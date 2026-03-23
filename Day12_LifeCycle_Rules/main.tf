resource "aws_instance" "name" {
   ami ="ami-0f559c3642608c138"
   instance_type = "t3.micro"

#LifeCycle Rules
    lifecycle {
    create_before_destroy = true
    }

    lifecycle {
    ignore_changes = [ tags ]
    }

    lifecycle {
      #prevent_destroy = true
    }

    tags = {
        Name = "dev-instance"
    }
}




 