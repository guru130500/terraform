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
  iam_instance_profile = aws_iam_instance_profile.example_profile.name
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
   iam_instance_profile = aws_iam_instance_profile.example_profile.name

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "Private_Subnet_Instance_${count.index}"
  }
}

#IAM Role creation
resource "aws_iam_role" "example" {
  name = "example_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy creation
resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "A test policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.my_bucket_created.arn,
          "${aws_s3_bucket.my_bucket_created.arn}/*"
        ]
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.example_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example.name
}


