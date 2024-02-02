terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }

  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "gideon_warui"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-015e832ac6a60f0de"
  instance_type = "t2.medium"
  user_data     = file("jenkins-install.sh")

  tags = {
    Name = "jenkins"
  }
}

resource "aws_security_group" "jenkins" {
  name = "jenkins"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_s3_bucket" "jenkins-artifacts-test-yakwetu" {
  bucket = "jenkins-artifacts-test-yakwetu"
}


