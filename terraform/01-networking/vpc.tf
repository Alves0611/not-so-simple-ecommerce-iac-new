resource "aws_vpc" "this" {
  cidr_block = var.vpc_resources.vpc_cidr_block

  tags = merge({ Name = var.vpc_resources.vpc }, var.tags)
}
