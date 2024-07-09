data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]  # Amazon's official AWS account ID
}

# instance creation block for public and private subnet
resource "aws_instance" "instances_in_subnets" {
    count = length(aws_subnet.public_subnets.*.id)+length(aws_subnet.private_subnets.*.id)
    ami = aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    key_name = "MyFirstkeypair.pem"
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    subnet_id = element(concat(aws_subnet.public_subnets.*.id, aws_subnet.private_subnets), count.index)

    root_block_device {
        volume_size = "8"
    }
    tags = {
        Name = "Instance_in_subnet_${element(concat(aws_subnet.public_subnets.*.id, aws_subnet.private_subnets.*.id), count.index)}"
    }
}