variable "allowed_ports" {
    type = map(string)
    default = {
    #key = value
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"
    3000  = "10.0.2.0/24"
  }
}  
resource "aws_security_group" "My-sg-rules1" {
  name        = "My-sg-rules1"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My-SG-Rules-different-CIDR"
  }
}


# variable "sgrule" {
#     type = list(string)
#     default = [ "22", "80", "443", "8080", "9000", "3000", "8082", "8081" ]
# }
#Defines a list of ports (only port numbers)

#A list is an ordered collection Values are accessed using index.
#var.sgrule[0] → "22"
#var.sgrule[1] → "80"
#Only stores values No extra information (like CIDR)

#A map is a key → value pair Access using key
#var.allowed_ports["22"] → "203.0.113.0/24"
#Port → CIDR
#ingress.key   → port
#ingress.value → CIDR

