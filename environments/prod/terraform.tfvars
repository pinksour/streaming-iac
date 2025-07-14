aws_region           = "ap-northeast-2"
environment          = "prod"

# 1. VPC
vpc_cidr             = "172.31.0.0/16"

# 2. AZ 리스트
azs                  = ["apne2-az1","apne2-az3"]

# 3. 퍼블릭 서브넷 (모듈이 새로 만드는 CIDR → 콘솔 확인된 CIDR 그대로 사용)
public_subnet_ids  = [
  "subnet-05ee35d77f51e58ca",    # WEB-PV-APNE2A
  "subnet-06fc8c1112aa20b99",    # WEB-PV-APNE2C
  "subnet-0dc4f56779ac99d43",    # WAS-PV-APNE2A
  "subnet-02149d60df849e30c",    # WAS-PV-APNE2C
  "subnet-085ce59be9f98ada2",    # RDS-Database-2A
  "subnet-0f38701902c589402"     # RDS-Database-2C
]

# 4. EC2 공통 설정
instance_type        = "t2.micro"
key_name             = "prod-key"
web_ami              = ""

# 5. 보안 그룹
sg_alb_id            = "sg-001a7f9f63a27bfb4"
sg_web_id            = "sg-07e2113edfa1f202f"
sg_nlb_id            = "sg-07072afa0dc2f7245"
sg_was_id            = "sg-05d3848aeae20216a"
rds_sg_ids           = ["sg-0e036f670ad9dc943"]

certificate_arn      = "arn:aws:acm:ap-northeast-2:123456789012:certificate/abcd-ef01-2345-6789"

db_username          = "admin"
db_password          = "1q2w3e4r"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_instance_class    = "db.t2.micro"
db_allocated_storage = 20

s3_bucket_name       = "streaming-serv-bucket"
service_data_path    = "../service-data"