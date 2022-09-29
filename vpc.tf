resource "aws_vpc" "ioana-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.owner}-vpc"
  }
}

resource "aws_subnet" "ioana-public-subnet-1" {
  cidr_block              = var.public_subnet_1_cidr
  vpc_id                  = aws_vpc.ioana-vpc.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.owner}-Public-Subnet-1"
  }
  depends_on = [aws_vpc.ioana-vpc]
}

resource "aws_subnet" "ioana-public-subnet-2" {
  cidr_block              = var.public_subnet_2_cidr
  vpc_id                  = aws_vpc.ioana-vpc.id
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.owner}-Public-Subnet-2"
  }
  depends_on = [aws_vpc.ioana-vpc]
}

resource "aws_subnet" "ioana-private-subnet-1" {
  cidr_block              = var.private_subnet_1_cidr
  vpc_id                  = aws_vpc.ioana-vpc.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.owner}-Private-Subnet-1"
  }
  depends_on = [aws_vpc.ioana-vpc]
}

resource "aws_subnet" "ioana-private-subnet-2" {
  cidr_block              = var.private_subnet_2_cidr
  vpc_id                  = aws_vpc.ioana-vpc.id
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.owner}-Private-Subnet-2"
  }
  depends_on = [aws_vpc.ioana-vpc]
}