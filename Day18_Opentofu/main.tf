resource "aws_instance" "name" {
    ami = "ami-0931307dcdc2a28c9"
    instance_type = "t3.micro"
    tags = {
        Name = "opentofu"
    }   
}

#opentofu fully open source terraform alternative, same hcl language, same commands, same state file, same providers, same modules, same configuration files, same workflow, but open source and free to use without any restrictions.
#tofu init, plan and apply commands are same as terraform, but the command is "tofu" instead of "terraform". It is fully compatible with terraform, so you can use the same configuration files and state files with tofu without any modifications.