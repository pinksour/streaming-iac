resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = var.name
  engine                 = var.engine
  engine_version         = "8.0.28"
  instance_class         = "db.t3.micro"
  allocated_storage      = var.allocated_storage
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true
  apply_immediately      = true
}

output "rds_endpoint" { value = aws_db_instance.this.endpoint }