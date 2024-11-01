provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Fetch available availability zones in the current AWS region
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "eks_subnets" {
  count = 2
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}