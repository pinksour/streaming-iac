variable "aws_region"           { type = string }
variable "environment"          { type = string }

# VPC Settings
variable "vpc_cidr"             { type = string }
variable "azs"                  { type = list(string) }
variable "public_subnet_cidrs"  { type = list(string) }

# AMI Settings
variable "web_ami"              { type = string }
variable "instance_type"        { type = string }
variable "key_name"             { type = string }

# Security Group Settings
variable "sg_alb_id"            { type = string }
variable "sg_web_id"            { type = string }
variable "sg_nlb_id"            { type = string }
variable "sg_was_id"            { type = string }
variable "rds_sg_ids"           { type = list(string) }

variable "certificate_arn"      { type = string }

# RDS
variable "db_username"          { type = string }
variable "db_password"          { type = string }
variable "db_engine"            { type = string }
variable "db_engine_version"    { type = string }
variable "db_instance_class"    { type = string }
variable "db_allocated_storage" { type = number }
variable "rds_sg_ids"           { type = list(string) }

# S3
variable "s3_bucket_name"       { type = string }
variable "service_data_path"    { type = string }