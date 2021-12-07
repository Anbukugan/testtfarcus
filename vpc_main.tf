resource "aws_vpc" "main" {
  count = length(var.vpc_name)
  cidr_block           = var.vpc_cidr[count.index]
  instance_tenancy     = var.instance_tenancy[count.index]
  enable_dns_support   = var.enable_dns_support[count.index]
  enable_dns_hostnames = var.enable_dns_hostnames[count.index]
  tags                 = merge({Name= var.vpc_name[count.index]},var.tag)
}