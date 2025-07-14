variable "name"       {
  description = "Prefix for NLB and TG names"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the NLB"
  type = list(string)
}

variable "vpc_id"     {
  description = "VPC ID where the NLB lives"
  type = string
}

variable "sg_nlb_id"  {
  description = "Security group ID to associate with the NLB"
  type = string
}

variable "targets" {
  description = <<EOF
  Map of target groups.
  Each key is a logical nam, each value describes:
  - port                : number
  - protocol            : "TCP"/"HTTP"/etc
  - instance_ids        : list of EC2 IDs
  - health_check_path : only for HTTP/HTTPS
  EOF
  type = map(object({
    port                 = number
    protocol             = string
    instance_ids         = list(string)
    health_check_path  = optional(string)
  }))
}