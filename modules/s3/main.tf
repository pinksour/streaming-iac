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

resource "aws_s3_object" "data" {
  for_each = { for f in local.files : f => f }
  bucket   = aws_s3_bucket.this.id
  key      = each.key
  source   = "${var.service_data_path}/${each.key}"
  etag     = filemd5("${var.service_data_path}/${each.key}")
}

output "bucket_name" { value = aws_s3_bucket.this.id }