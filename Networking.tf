data "aws_availability_zones" "available" {}
provider "aws" {
    region = "us-west-1"
}
resource "aws_vpc" "main_vpc" {

    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_internet_gateway" "mygateway" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "My_internet_connection"
    }
}


resource "aws_default_route_table" "terraform_default_rt"{
    default_route_table_id = aws_default_route_table.terraform_default_rt.id

    tags = {
        Name = "default_rout_table"

    }
}
resource "aws_route_table" "my_public_route_table" {

    vpc_id = aws_vpc.main_vpc.id
   tags = {
    Name = "private_route_table"
   }


}

resource "aws_route" "internet_adding_route" {
    route_table_id = aws_route_table.my_public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
}

resource "aws_security_group" "my_security_group" {
    name = "mycreated_sg"
    vpc_id = aws_vpc.main_vpc.id
}
resource "aws_security_group_rule" "ingress" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.my_security_group.id
}
resource "aws_security_group_rule" "egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.my_security_group.id
}
 
 resource "aws_subnet" "public_subnets" {
     vpc_id = aws_vpc.main_vpc.id
     count = 2
     cidr_block = var.public_subnet_cidr[count.index]
     map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]
 }

 resource "aws_subnet" "private_subnets" {
     vpc_id = aws_vpc.main_vpc.id
     count = 2
     cidr_block = var.private_subnet_cidr[count.index]
     map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[count.index]
 }
resource "aws_route_table_association" "public_route_table_association" {
    route_table_id = aws_route_table.my_public_route_table.id
    subnet_id = aws_subnet.public_subnets.*.id[count.index]
    count = 2
}
resource "aws_route_table_association" "private_route_table_association" {
    route_table_id = aws_default_route_table.terraform_default_rt.id
    subnet_id =  aws_subnet.private_subnets.*.id[count.index]
    count =2 
}