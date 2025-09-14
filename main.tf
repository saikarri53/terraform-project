provider "aws" {
  region = "us-east-1"
}

############################
# SECURITY GROUP
############################
resource "aws_security_group" "five" {
  name        = "elb-sg"
  description = "Allow HTTP + SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP for better security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "elb-sg"
    Environment = "dev"
  }
}

############################
# WEB SERVERS
############################
resource "aws_instance" "one" {
  ami                    = "ami-06018068a18569ff2"
  instance_type          = "t2.micro"
  key_name               = "sai9121"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1a"

  user_data = <<-EOF
    #!/bin/bash
    yum install httpd -y
    systemctl start httpd
    chkconfig httpd on
    echo "hai all this is my app created by terraform infrastructure by raham sir server-1" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "web-server-1"
    Environment = "dev"
  }
}

resource "aws_instance" "two" {
  ami                    = "ami-06018068a18569ff2"
  instance_type          = "t2.micro"
  key_name               = "sai9121"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1b"

  user_data = <<-EOF
    #!/bin/bash
    yum install httpd -y
    systemctl start httpd
    chkconfig httpd on
    echo "hai all this is my website created by terraform infrastructure by raham sir server-2" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "web-server-2"
    Environment = "dev"
  }
}

############################
# APP SERVERS
############################
resource "aws_instance" "three" {
  ami                    = "ami-06018068a18569ff2"
  instance_type          = "t2.micro"
  key_name               = "sai9121"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name        = "app-server-1"
    Environment = "dev"
  }
}

resource "aws_instance" "four" {
  ami                    = "ami-06018068a18569ff2"
  instance_type          = "t2.micro"
  key_name               = "sai9121"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1b"

  tags = {
    Name        = "app-server-2"
    Environment = "dev"
  }
}

############################
# S3 BUCKET (WITH RANDOM SUFFIX)
############################
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "six" {
  bucket = "devopsbyraham-${random_id.suffix.hex}"

  tags = {
    Name        = "terraform-s3"
    Environment = "dev"
  }
}

############################
# IAM USERS
############################
resource "aws_iam_user" "seven" {
  for_each = var.user_names
  name     = each.value

  tags = {
    Environment = "dev"
  }
}

variable "user_names" {
  description = "IAM Users to Create"
  type        = set(string)
  default     = ["user1", "user2", "user3", "user4"]
}

############################
# EBS VOLUME (FIXED REGION)
############################
resource "aws_ebs_volume" "eight" {
  availability_zone = "us-east-1a"
  size              = 40

  tags = {
    Name        = "ebs-001"
    Environment = "dev"
  }
}
