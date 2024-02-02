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

resource "aws_instance" "jenkins" {
    ami = "ami-0f960def03d1071d3"
    instance_type = "t2.medium"
    tags = {
        Name = "jenkins"
    }

    user_data = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo dnf install java-17-amazon-corretto -y
        sudo yum install wget -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
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

resource "aws_s3_bucket" "jenkins-artifacts-test-yakwetu" {
    bucket = "jenkins-artifacts-test-yakwetu"
}


