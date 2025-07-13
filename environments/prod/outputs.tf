output "alb_dns"  { value = module.alb.alb_dns }
output "nlb_dns"  { value = module.nlb.nlb_dns }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "s3_bucket" { value = module.s3.bucket_name }