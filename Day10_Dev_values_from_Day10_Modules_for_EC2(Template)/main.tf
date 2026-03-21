module "dev" {
    source = "../Day10_Module_for_EC2(Template)" 
    ami_id = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
}
#source will be cloned from Day10_Module_for_EC2(Template) folder and we will use that code in Day10_Dev_values_from_Day10_Modules_for_EC2 main.tf file.