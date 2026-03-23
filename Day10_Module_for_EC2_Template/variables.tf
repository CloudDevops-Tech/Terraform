variable "ami_id" {
    default = ""
}
variable "instance_type" {
    default = ""
}
variable "subnet_id" {
    default = ""
}

variable "name" {   
  default = "my-instance"
}

# Networking
variable "security_group_ids" {
  default = []
}
variable "public_ip" {
  default = true
}

# Access
variable "key_name" {
  description = "SSH key pair"
  default = ""
}

# IAM
variable "iam_instance_profile" {
  default = null
}

# Storage
variable "volume_size" {
  default = 8
}
variable "volume_type" {
  default = "gp3"
}

variable "device_name" {
  default = "/dev/sdf"
}
variable "ebs_volume_size" {
  default = 10
}
variable "ebs_volume_type" {
  default = "gp3"
}

# Monitoring
variable "enable_monitoring" {
  default = false
}

# User data (startup script)
variable "user_data" {
  default = ""
}

# Tags
variable "tags" {
  type    = map(string)
  default = {}
}