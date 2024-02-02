terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.35.0"
        }
    
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "jenkins" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    tags = {
        Name = "jenkins"
    }

    user_data = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install java-1.8.0 -y
        sudo yum install wget -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        sudo rpm --import XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        sudo yum upgrade -y
        sudo yum install jenkins -y
        sudo systemctl daemon-reload
        sudo systemctl start jenkins
        sudo systemctl enable jenkins
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    EOF
}

resource "aws_security_group" "jenkins" {
    name = "jenkins"
    vpc_id = "vpc-0c1f3d3b3d3b3d3b3"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "jenkins-artifacts" {
    bucket = "jenkins-artifacts"
}


