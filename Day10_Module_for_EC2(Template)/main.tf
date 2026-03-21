resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = var.public_ip

  iam_instance_profile = var.iam_instance_profile

  user_data = var.user_data

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  ebs_block_device {
    device_name = var.device_name
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  monitoring = var.enable_monitoring

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}