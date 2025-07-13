variable "aws_region"       { type = string }
variable "environment"      { type = string }
variable "vpc_cidr"         { type = string }
variable "azs"              { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "web_ami"          { type = string }
variable "instance_type"    { type = string }
variable "key_name"         { type = string }
variable "sg_web_id"        { type = string }
variable "certificate_arn"  { type = string }

# RDS
variable "db_username"      { type = string }
variable "db_password"      { type = string }
variable "db_engine"        { type = string }
variable "db_engine_version"{ type = string }
variable "db_instance_class"{ type = string }
variable "db_allocated_storage"{ type = number }
variable "rds_sg_ids"       { type = list(string) }

# S3
variable "s3_bucket_name"   { type = string }
variable "service_data_path"{ type = string }