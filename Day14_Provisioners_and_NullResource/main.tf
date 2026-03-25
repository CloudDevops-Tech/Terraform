# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_rsa.pub")
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC"
  }
}

# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate Route Table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Security Group
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (Ubuntu)
resource "aws_instance" "server" {
  ami                         = "ami-05d2d839d4f73aafb" # Ubuntu AMI
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.example.key_name
  subnet_id                   = aws_subnet.sub1.id
  vpc_security_group_ids      = [aws_security_group.webSg.id]
  associate_public_ip_address = true
  tags = {
    Name = "UbuntuServer"
  }
#Connection Block
  connection {
    type        = "ssh"
    user        = "ubuntu"                          # Correct for Ubuntu AMIs
    private_key = file("~/.ssh/id_rsa")             # Path to private key
    host        = self.public_ip
    timeout     = "2m"
#Connection is needed for:
#file provisioner
#remote-exec
#Without this → Provisioners fail
  }

#File Provisioner
   provisioner "file" {
     source      = "file10"
     destination = "/home/ubuntu/file10"
#Copies file:
#FROM: your local machine
#TO: EC2 server
#Result on EC2:/home/ubuntu/file10
   }

#Remote Execution
   provisioner "remote-exec" {
     inline = [
       "touch /home/ubuntu/file200",
       "echo 'hello from Terraform' >> /home/ubuntu/file200"
     ]
#Runs commands inside EC2 via SSH
#Result on EC2:file200 created
#content added:hello from Terraform
   }

#local Execution
    provisioner "local-exec" {
     command = "touch file500" 
#After EC2 is created:This runs on YOUR system (not EC2).
#Result:file500 → created in your local folder.
}
 }


#Null Resource - always run trigger
/*resource "null_resource" "run_script" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.server.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "echo 'hello from Devops' >> /home/ubuntu/file200"
    ]
  }

  triggers = {
    always_run = "${timestamp()}" # Forces terraform to re-run every time
  }
}*/


#Null Resource - Trigger only when script changes
resource "null_resource" "run_script" {

  # Copy script to EC2
  provisioner "file" {
    source      = "script.sh"
    destination = "/home/ubuntu/script.sh"

    connection {
      host        = aws_instance.server.public_ip
      user        = "ubuntu"
      private_key = file(pathexpand("~/.ssh/id_rsa"))
    }
  }

  # Execute script
  provisioner "remote-exec" {
   inline = [
  "chmod +x /home/ubuntu/script.sh",
  "bash /home/ubuntu/script.sh"
]

    connection {
      host        = aws_instance.server.public_ip
      user        = "ubuntu"
      private_key = file(pathexpand("~/.ssh/id_rsa"))
    }
  }

  # Trigger only when script changes
  triggers = {
    script_hash = filemd5("script.sh")
  }
}


#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply