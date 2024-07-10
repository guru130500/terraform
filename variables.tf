variable "public_subnet_cidr" {
    type = list(string)
    
}
variable "private_subnet_cidr" {
    type = list(string)
    
}
variable "vpc_cidr" {
    type = string
    
}

variable "s3_bucket_name" {
    type = string 
    default = "123_example_s3_for_build"
}

variable "region" {
    type = string 
    
}

variable "project_vpc_name" {
    type = string
}

variable "project_igw_name" {
    type = string
}

variable "dev_route_table_name" {
    type = string
}
variable "security_group_name" {
    type  string
}

variable "public_subnet_names" {
    type = list(string)
}
variable "private_subnet_names" {
    type = list(string)
}