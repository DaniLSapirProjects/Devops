terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "daniel-dev-vpc" {
  cidr_block = "172.22.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Daniel-dev-vpc"
  }
}

# Creating private subnets
resource "aws_subnet" "Daniel-k8s-subnet" {
  vpc_id = "${aws_vpc.daniel-dev-vpc.id}"
  cidr_block = "172.22.0.0/27"
  tags = {
    Name = "Daniel-k8s-subnet"
  }
}

# Create GW
resource "aws_internet_gateway" "Daniel-IGW" {
  vpc_id = "${aws_vpc.daniel-dev-vpc.id}"

  tags = {
    Name = "Daniel-IGW"
  }
}

# Create a NIC for a host use
resource "aws_network_interface" "NIC-Web" {
  subnet_id = "${aws_subnet.Daniel-k8s-subnet.id}"
  private_ips = ["172.22.0.9"]

  tags = {
    Name = "Host 172.22.0.9 NIC - Daniel-Subnet"
  }
}

