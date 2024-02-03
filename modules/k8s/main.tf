terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.35.0"
        }
    }
}

provider "aws" {
    region = "us-west-1"
    profile = "gideon_warui"
}

resource "aws_instance" "k8s" {
    ami = "ami-0a313d6098716f372"
    instance_type = "t2.micro"
    user_data = file("k8s-install.sh")
    tags = {
        Name = "k8s"
    }
}