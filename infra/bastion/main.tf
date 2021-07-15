provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc_state" {
  backend = "local"
  config = {
    path = "${path.module}/../vpc/terraform.tfstate"
  }
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = data.terraform_remote_state.vpc_state.outputs.vpc_id

  tags = {
    Name = "bastion-instance-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0dc2d3e4c0f9ebd18"
  instance_type               = "t2.micro"
  key_name                    = "adam-mbp"
  associate_public_ip_address = true
  subnet_id                   = data.terraform_remote_state.vpc_state.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion Host"
  }
}
