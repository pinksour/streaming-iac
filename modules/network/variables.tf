variable "name"              { type = string }
variable "vpc_cidr"          { type = string }
variable "azs"               { type = list(string) }
variable "public_subnet_ids" { type = list(string) }