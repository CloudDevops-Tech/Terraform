module "dev" {
    source = "../Day2_Terraform_allfiles_config" #source will be cloned from day-2 folder and we will use that code in day-9 main.tf file
    ami_id = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
}

#iam passing the values from day-9 to day-2 so source code exist into day-2 only for reference purpose but we are not going to use that code in day-9 because we are going to create module for that code and we will call that module in day-9 main.tf file
