provider "aws" {
    region = "ap-south-1"
}
 resource "aws_instance" "terra" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"

    
  user_data = <<-EOF
              #!/bin/bash

              # Update system
              apt update -y

              # Install Docker
              apt install docker.io -y
              systemctl start docker
              systemctl enable docker

              # Install Apache (httpd)
              apt install apache2 -y
              systemctl start apache2
              systemctl enable apache2

              # Install Kubernetes tools
              apt install -y apt-transport-https ca-certificates curl

              curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

              cat <<EOT >> /etc/apt/sources.list.d/kubernetes.list
              deb https://apt.kubernetes.io/ kubernetes-xenial main
              EOT

              apt update -y
              apt install -y kubelet kubeadm kubectl

              EOF

  tags = {
    Name = "DevOps-EC2"
  }
}
