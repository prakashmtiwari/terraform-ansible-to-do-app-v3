terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = var.region
}

resource "aws_instance" "tf-separate-fontend" {
    ami           = var.ami_id
    instance_type = var.instance_type

    tags = {
      Name = "tf-separate-frontend"
    }
    key_name = var.key_name
    vpc_security_group_ids = [
    aws_security_group.allow_frontend.id
    ]
}

resource "aws_instance" "tf-separate-backend" {
    ami           = var.ami_id
    instance_type = var.instance_type

    tags = {
      Name = "tf-separate-backend"
    }
    key_name = var.key_name
    vpc_security_group_ids = [
    aws_security_group.allow_backend.id
    ]
}

resource "aws_security_group" "allow_frontend" {
  name        = "allow_frontend"
  description = "Allow frontend inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_frontend"
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "allow_backend" {
  name        = "allow_backend"
  description = "Allow backend inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_backend"
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
