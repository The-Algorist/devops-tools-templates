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

resource "aws_instance" "docker-instance" {
    ami           = "ami-015e832ac6a60f0de"
    instance_type = "t2.micro"
    user_data     = file("docker-install.sh")
  
    tags = {
        Name = "docker"
    }
  
}

resource "aws_security_group" "docker" {
    name = "docker"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        from_port   = 80
        to_port     = 80
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