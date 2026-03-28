# ─────────────────────────────
# VPC Module
# ─────────────────────────────
module "vpc" {
  source                 = "../../modules/infrastructure"
  aws_region             = var.aws_region
  vpc_cidr               = var.vpc_cidr
  vpc_name               = var.vpc_name
  vpc_id                  = module.vpc.vpc_id
  public_subnet_1_cidr   = var.public_subnet_1_cidr
  public_subnet_2_cidr   = var.public_subnet_2_cidr
  private_subnet_1_cidr  = var.private_subnet_1_cidr
  private_subnet_2_cidr  = var.private_subnet_2_cidr
  private_subnet_3_cidr  = var.private_subnet_3_cidr
  private_subnet_4_cidr  = var.private_subnet_4_cidr
  private_subnet_5_cidr  = var.private_subnet_5_cidr
  private_subnet_6_cidr  = var.private_subnet_6_cidr
  availability_zone_1a   = var.availability_zone_1a
  availability_zone_1b   = var.availability_zone_1b
  allowed_ssh_cidr       = var.allowed_ssh_cidr
}

# ─────────────────────────────
# EC2 Modules
# ─────────────────────────────
module "frontend-ec2" {
  source            = "../../modules/frontend/ec2"
  aws_region        = var.aws_region
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.public_subnets[0]
  security_group_id = module.vpc.bastion_sg_id
}

module "backend-ec2" {
  source            = "../../modules/backend/ec2"
  aws_region        = var.aws_region
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.public_subnets[0]
  security_group_id = module.vpc.bastion_sg_id
}

module "bastion" {
  source            = "../../modules/bastion"
  aws_region        = var.aws_region
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.public_subnets[0]
  security_group_id = module.vpc.bastion_sg_id
}

# ─────────────────────────────
# ALB Modules
# ─────────────────────────────
module "frontend_alb" {
  source             = "../../modules/frontend/loadbalancer-frontend"
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_group_id  = module.vpc.alb_frontend_sg_id
  alb_name           = "frontend-alb"
  target_group_name  = "frontend-tg"
}

module "backend_alb" {
  source             = "../../modules/backend/loadbalancer-backend"
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_group_id  = module.vpc.alb_backend_sg_id
  alb_name           = "backend-alb"
  target_group_name  = "backend-tg"
}

# ─────────────────────────────
# RDS Module
# ─────────────────────────────
module "rds" {
  source            = "../../modules/database"
  aws_region        = var.aws_region
  project_name      = "three-tier"
  identifier        = "book-rds"
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  multi_az          = var.db_multi_az
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_subnet_1_id    = module.vpc.private_db_subnets[0]
  db_subnet_2_id    = module.vpc.private_db_subnets[1]
  rds_sg_id         = module.vpc.database_sg_id
}

# ─────────────────────────────
# Launch Templates
# ─────────────────────────────
module "frontend_launchtemplate" {
  source           = "../../modules/frontend/launch-template"
  aws_region       = var.aws_region
  project_name     = "three-tier"
  instance_type    = var.instance_type
  frontend_sg_id   = module.vpc.frontend_server_sg_id
  key_name         = var.key_name
  instanceid       = module.frontend-ec2.frontend_instanceid
}

module "backend_launchtemplate" {
  source           = "../../modules/backend/launch-template"
  aws_region       = var.aws_region
  project_name     = "three-tier"
  instance_type    = var.instance_type
  backend_sg_id    = module.vpc.backend_server_sg_id
  key_name         = var.key_name
  instanceid       = module.backend-ec2.backend_instanceid
}

# ─────────────────────────────
# Auto Scaling Groups
# ─────────────────────────────
module "asg-backend" {
  source                     = "../../modules/backend/asg"
  aws_region                 = var.aws_region
  project_name               = "books-three-tier"
  backend_launch_template_id = module.backend_launchtemplate.backend_launch_template_id
  app_subnet_1_id            = module.vpc.private_app_subnets[0]
  app_subnet_2_id            = module.vpc.private_app_subnets[1]
  backend_target_group_arn   = module.backend_alb.alb_target_group_arn
  backend_desired_capacity   = var.backend_desired_capacity
  backend_min_size           = var.backend_min_size
  backend_max_size           = var.backend_max_size
  scale_out_target_value     = var.scale_out_target_value
}

module "asg-frontend" {
  source                      = "../../modules/frontend/asg"
  aws_region                  = var.aws_region
  project_name                = "books-three-tier"
  frontend_launch_template_id = module.frontend_launchtemplate.frontend_launch_template_id
  web_subnet_1_id             = module.vpc.public_subnets[0]
  web_subnet_2_id             = module.vpc.public_subnets[1]
  frontend_target_group_arn   = module.frontend_alb.alb_target_group_arn
  frontend_desired_capacity   = var.frontend_desired_capacity
  frontend_min_size           = var.frontend_min_size
  frontend_max_size           = var.frontend_max_size
  scale_out_target_value      = var.scale_out_target_value
}