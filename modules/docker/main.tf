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
    instance_type = "t2.medium"
    user_data     = file("docker-install.sh")
  
    tags = {
        Name = "docker"
    }
  
}