provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "aws-s3-bucket-uniqque-code"  # Change this to your desired bucket name
  acl    = "private"

  tags = {
    Project    = "CLOD1003"
    "Created by" = "PRATIK"
  }
}

resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow inbound connections on port 80 and 443"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project    = "CLOD1003"
    "Created by" = "PRATIK"
  }
}

resource "aws_instance" "ec2" {
  count         = 2
  ami           = "ami-0230bd60aa48260c6"  # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]

  tags = {
    Project    = "CLOD1003"
    "Created by" = "PRATIK"
  }
}

resource "aws_iam_user" "user" {
  name = "test-user-delete"  # Change this to your desired IAM username
  path = "/"

  tags = {
    Project    = "CLOD1003"
    "Created by" = "PRATIK"
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name   = "s3-full-access"
  user   = aws_iam_user.user.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "s3:*",
      Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*",
    }],
  })
}
