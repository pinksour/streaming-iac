data "aws_vpc" "selected" {
  id = module.network.vpc_id
}

module "network" {
  source              = "../../modules/network"
  name                = var.environment
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
}

# EC2 instances
resource "aws_instance" "web" {
  ami                         = var.web_ami
  instance_type               = var.instance_type
  subnet_id                   = module.network.public_subnets[0]
  vpc_security_group_ids      = [ var.sg_web_id ]
  associate_public_ip_address = true
  tags = {
    Name = "${var.environment}-web"
  }
}

resource "aws_instance" "login" {
  ami                    = var.web_ami
  instance_type          = var.instance_type
  subnet_id              = module.network.public_subnets[1]
  vpc_security_group_ids = [ var.sg_was_id ]
  tags = {
    Name = "${var.environment}-login"
  }
}

resource "aws_instance" "db" {
  ami                    = var.web_ami
  instance_type          = var.instance_type
  subnet_id              = module.network.public_subnets[2]
  vpc_security_group_ids = var.rds_sg_ids
  tags = {
    Name = "${var.environment}-db"
  }
}

resource "aws_instance" "media" {
  ami                    = var.web_ami
  instance_type          = var.instance_type
  subnet_id              = module.network.public_subnets[3]
  vpc_security_group_ids = [ var.sg_nlb_id ]
  tags = {
    Name = "${var.environment}-media"
  }
}

module "alb" {
  source             = "../../modules/alb"
  name               = var.environment
  subnet_ids         = module.network.public_subnets
  sg_alb_id          = var.sg_alb_id
  sg_web_id          = var.sg_web_id
  certificate_arn    = var.certificate_arn
  vpc_id             = data.aws_vpc.selected.id
}

module "nlb" {
  source     = "../../modules/nlb"
  name       = var.environment
  subnet_ids = module.network.public_subnets
  sg_nlb_id  = var.sg_nlb_id
  vpc_id     = data.aws_vpc.selected.id
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
  source                 = "../../modules/rds"
  name                   = var.environment
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = var.db_password
  subnet_ids             = module.network.public_subnets
  vpc_security_group_ids = var.rds_sg_ids
}

module "s3" {
  source             = "../../modules/s3"
  bucket             = var.s3_bucket_name
  service_data_path  = var.service_data_path
}