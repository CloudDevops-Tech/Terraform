output "public_ip" {
    value = aws_instance.name.public_ip
  }

  output "private_ip" {
    value = aws_instance.name.private_ip
  }

  output "availability_Zone" {
    value = aws_instance.name.availability_zone
  }
  