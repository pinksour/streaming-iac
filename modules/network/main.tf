resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.name}-vpc" }
}

#resource "aws_subnet" "public" {
#  for_each = zipmap(var.azs, var.public_subnet_cidrs)
#  vpc_id                  = aws_vpc.this.id
#  availability_zone       = each.key
#  cidr_block              = each.value
#  map_public_ip_on_launch = true
#  tags = { Name = "${var.name}-public-${each.key}" }
#}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = var.public_subnet_ids
}