provider "aws" {
  region = "ap-south-1"
}

# 🔐 Security Group
resource "aws_security_group" "my_sg" {
  name = "allow_ssh_http"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
}

# 🚀 EC2 Instance
resource "aws_instance" "terra" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  key_name = "bastion-key"  # ⚠️ IMPORTANT (create in AWS)

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              apt update -y

              # Docker
              apt install docker.io -y
              systemctl start docker
              systemctl enable docker

              # Apache
              apt install apache2 -y
              systemctl start apache2
              systemctl enable apache2

              # Kubernetes tools
              apt install -y apt-transport-https ca-certificates curl

              curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

              echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

              apt update -y
              apt install -y kubelet kubeadm kubectl
              EOF

  tags = {
    Name = "DevOps-EC2"
  }
}