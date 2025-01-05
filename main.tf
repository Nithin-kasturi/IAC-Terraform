#Provider on which we want to configure infrastructure
provider "aws" {}
#Declaring and assigning values variables
variable "subnet-cidr-block" {
    description = "value for subnet-cidr-block"
}
variable "VPC-cidr-block" {
    description = "value for VPC-cidr-block"
}
#Creating a VPC in your aws
resource "aws_vpc" "development-vpc" {
    cidr_block = var.VPC-cidr-block
    tags = {
      Name="Development-vpc"
    }
}
#Create a subnet inside the VPC
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = "us-east-1a"
  tags = {
    Name="Subnet-1-dev"
  }
}
