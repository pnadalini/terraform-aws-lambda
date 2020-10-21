# Locals

locals {
  cidr_block = "10.192.0.0/16"
  public_subnet_cidrs = [
    "10.192.10.0/16"
  ]
  private_subnet_cidrs = [
    "10.192.20.0/16"
  ]
  vpc_tags = {
    "Name" = "${var.env}:vpc"
  }
  public_subnet_tags = {
    "Name" = "${var.env}:public"
  }
  private_subnet_tags = {
    "Name" = "${var.env}:private"
  }
  public_rt_tags = {
    "Name" = "${var.env}:public-rt"
  }
  private_rt_tags = {
    "Name" = "${var.env}:private-rt"
  }
}

# VPC

resource "aws_vpc" "vpc" {
  cidr_block       = local.cidr_block
  instance_tenancy = "default"
  tags = local.vpc_tags
}

# Subnets 

resource "aws_subnet" "public" {
  count      = length(local.public_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.public_subnet_cidrs[count.index]
  tags       = local.public_subnet_tags
}

resource "aws_subnet" "private" {
  count      = length(local.private_subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.private_subnet_cidrs[count.index]
  tags       = local.private_subnet_tags
}

# Internet Gateways

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}:igw"
  }
}

resource "aws_eip" "nat" {
  count = length(local.private_subnet_cidrs)
  vpc   = true

  tags = {
    Name = "${var.env}:nat-${count.index}"
  }
}

resource "aws_nat_gateway" "app" {
  count         = length(local.private_subnet_cidrs)
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

# Route Tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = local.public_rt_tags
}

resource "aws_route_table" "private" {
  count  = length(aws_nat_gateway.app)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app.*.id[count.index]
  }

  tags = local.private_rt_tags
}

# Route Table Association

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_cidrs)
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}
