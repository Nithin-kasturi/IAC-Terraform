#Provider on which we want to configure infrastructure
provider "aws" {}
#Declaring and assigning values variables
variable "subnet-cidr-block" {
    description = "value for subnet-cidr-block"
}
variable "VPC-cidr-block" {
    description = "value for VPC-cidr-block"
}
variable "availability_zone" {
    description = "Availability zone for subnet-1"
}
variable "my-ip" {
    description = "My IP address"
}
#Creating a VPC in your aws
resource "aws_vpc" "my-app-vpc" {
    cidr_block = var.VPC-cidr-block
    tags = {
      Name="my-app-vpc"
    }
}
#Create a subnet inside the VPC
resource "aws_subnet" "my-app-subnet-1" {
  vpc_id = aws_vpc.my-app-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = var.availability_zone
  tags = {
    Name="Subnet-1-my-app"
  }
}

#Route table for the subnet in vpc
resource "aws_route_table" "my-app-route-table" {
  vpc_id = aws_vpc.my-app-vpc.id
  route {
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.my-app-igw.id
  }
  tags = {
    Name="my-app-route-table"
  }
}
#Internet gateway to handle the incoming and outgoing routes on subnets
resource "aws_internet_gateway" "my-app-igw" {
  vpc_id = aws_vpc.my-app-vpc.id
  tags={
    Name="my-app-igw"
  }
}
#Associate my-app-subnet-1 to the route table
resource "aws_route_table_association" "my-app-subnet-1-route-table-asoc" {
  subnet_id = aws_subnet.my-app-subnet-1.id
  route_table_id = aws_route_table.my-app-route-table.id
}
#Security group Creation
resource "aws_security_group" "my-app-sg" {
  name="my-app-sg"
  vpc_id=aws_vpc.my-app-vpc.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my-ip ]
  }  
  ingress{
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0" ]
  }  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    prefix_list_ids = []
  }
  tags = {
    Name="my-app-sg"
  }
  
}