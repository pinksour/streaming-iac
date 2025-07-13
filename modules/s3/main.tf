resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  # (acl은 별도 aws_s3_bucket_acl로 처리)
}

resource "aws_s3_bucket_acl" "this_acl" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

locals {
  files = fileset(var.service_data_path, "**/*")
}

output "bucket_name" { value = aws_s3_bucket.this.id }