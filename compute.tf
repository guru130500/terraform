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

resource "aws_instance" "public_subnet_instances" {
  count = length(aws_subnet.public_subnets.*.id)
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name = "myFirstKeyPair"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id = aws_subnet.public_subnets[count.index].id

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "Public_Subnet_Instance_${count.index}"
  }
}

resource "aws_instance" "private_subnet_instances" {
  count = length(aws_subnet.private_subnets.*.id)
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name = "myFirstKeyPair"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id = aws_subnet.private_subnets[count.index].id

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "Private_Subnet_Instance_${count.index}"
  }
}

