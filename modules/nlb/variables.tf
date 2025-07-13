variable "name"       { type = string }
variable "subnet_ids" { type = list(string) }
variable "targets" {
  type = map(object({
    port               = number
    protocol           = string
    instance_ids       = list(string)
    health_check_path  = string
  }))
}