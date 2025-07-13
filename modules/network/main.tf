resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.name}-vpc" }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = var.public_subnet_ids
}