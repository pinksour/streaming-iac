variable "env" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling group"
  type        = list(string)
}

variable "asg_min" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "List of ALB/NLB target group ARNs to attach to the ASG"
  type        = list(string)
}

# (Optional) user_data script path is hardcoded in module; no variable needed here