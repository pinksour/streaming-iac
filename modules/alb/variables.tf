variable "name"               { type = string }
variable "subnet_ids"         { type = list(string) }
variable "sg_alb_id"          { type = string }
variable "sg_web_id"          { type = string }
variable "certificate_arn"    { type = string }
variable "vpc_id"             { type = string }