resource "aws_security_group" "public_instance" {
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-instance-sg"
  }
}

resource "aws_security_group" "ssh_self" {
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    self      = true
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-self-sg"
  }
}
