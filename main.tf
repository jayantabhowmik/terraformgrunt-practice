module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "Terraform-EC2"

  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.terraform-ec2-security-group.id]
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}


resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "/Users/jbhowmik/${var.key_name}.pem"
  file_permission = "0400"
}


resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}


resource "aws_security_group" "terraform-ec2-security-group" {
  name        = "ec2-security-group-terraform"
  description = "Allow SSH and HTTP access created using terraform"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}