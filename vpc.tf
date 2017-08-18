# Configure the AWS Provider
provider "aws" {
  region     = "us-west-1"
}

# Define a vpc
resource "aws_vpc" "ecsVPC" {
  cidr_block = "200.0.0.0/16"
  tags {
    Name = "ecsVPC"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ecsIG" {
  vpc_id = "${aws_vpc.ecsVPC.id}"
  tags {
    Name = "ecsIG"
  }
}

# Public subnet
resource "aws_subnet" "ecsPubSN0-0" {
  vpc_id = "${aws_vpc.ecsVPC.id}"
  cidr_block = "200.0.0.0/24"
  availability_zone = "us-west-1a"
  tags {
    Name = "ecsPubSN0-0-0"
  }
}

# Routing table for public subnet
resource "aws_route_table" "ecsPubSN0-0RT" {
  vpc_id = "${aws_vpc.ecsVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecsIG.id}"
  }
  tags {
    Name = "ecsubSN0-0RT"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "ecsPubSN0-0RTAssn" {
  subnet_id = "${aws_subnet.ecsPubSN0-0.id}"
  route_table_id = "${aws_route_table.ecsPubSN0-0RT.id}"
}
