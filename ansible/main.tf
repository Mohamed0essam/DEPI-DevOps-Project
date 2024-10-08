provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key"
  public_key = file("/home/ahmedkhalid/.ssh/my-key.pub")
}

resource "aws_security_group" "allow_all_ports" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "kubernetes" {
  ami                         = "ami-0e86e20dae9224db8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_key_pair.key_name

  tags = {
    "Name" = "kubernetes"
  }

  security_groups = [
    aws_security_group.allow_all_ports.name
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y software-properties-common
              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install -y ansible
              sudo apt install -y python3-pip
              ansible-galaxy collection install amazon.aws --force
              sudo apt install -y python3-boto3

              curl -sfL https://get.k3s.io | sh -

              # Ensure kubeconfig permissions are set
              mkdir -p /home/ubuntu/.kube
              sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
              sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
              sudo chmod 644 /home/ubuntu/.kube/config
              echo 'export KUBECONFIG=/home/ubuntu/.kube/config' >> /home/ubuntu/.bashrc
              EOF

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ahmedkhalid/.ssh/my-key")
    host        = self.public_ip
  }
}

resource "aws_instance" "jenkins" {
  ami                         = "ami-0e86e20dae9224db8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_key_pair.key_name

  tags = {
    "Name" = "jenkins"
  }

  security_groups = [
    aws_security_group.allow_all_ports.name
  ]
}