data "aws_vpc" "selected" {
  id = module.network.vpc_id
}

module "network" {
  source             = "../../modules/network"
  name               = var.environment
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  public_subnet_cidrs= var.public_subnet_cidrs
}

module "alb" {
  source             = "../../modules/alb"
  name               = var.environment
  subnet_ids         = module.network.public_subnets
  security_group_ids = [var.sg_web_id]
  certificate_arn    = var.certificate_arn
}

# EC2 인스턴스(Listed outside of Terraform or via aws_instance)
# aws_instance.web_frontend is assumed to exist and in SG var.sg_web_id

module "nlb" {
  source     = "../../modules/nlb"
  name       = var.environment
  subnet_ids = module.network.public_subnets
  targets = {
    login = {
      port              = 3001
      protocol          = "TCP"
      instance_ids      = [aws_instance.login.id]
      health_check_path = "/health"
    }
    db = {
      port              = 3002
      protocol          = "TCP"
      instance_ids      = [aws_instance.db.id]
      health_check_path = "/health"
    }
    media = {
      port              = 3003
      protocol          = "TCP"
      instance_ids      = [aws_instance.media.id]
      health_check_path = "/health"
    }
  }
}

module "rds" {
  source                = "../../modules/rds"
  name                  = var.environment
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  username              = var.db_username
  password              = var.db_password
  subnet_ids            = module.network.public_subnets
  vpc_security_group_ids= var.rds_sg_ids
}

module "s3" {
  source             = "../../modules/s3"
  bucket             = var.s3_bucket_name
  service_data_path  = var.service_data_path
}