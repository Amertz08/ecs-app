provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "app_cloud" {
  # 10.0.0.0 - 10.0.255.255
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "ECS App"
    managed = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.app_cloud.id
  # 10.0.0.0 - 10.0.0.255
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "ECS App Public"
    managed = "Terraform"
  }
}

resource "aws_security_group" "public-sg" {
  name        = "allow_ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.app_cloud.id
}

resource "aws_security_group_rule" "public-sg-ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.public-sg.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.app_cloud.id
  # 10.0.1.0 - 10.0.1.255
  cidr_block = "10.0.1.0/24"

  tags = {
    Name    = "ECS App Private"
    managed = "Terraform"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.app_cloud.id
  tags = {
    Name    = "ECS App Public"
    managed = "Terraform"
  }
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private.id
  tags = {
    Name    = "ECS App Private"
    managed = "Terraform"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name    = "ecs-app-nat-eip"
    managed = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_cloud.id
  tags = {
    Name    = "ECS App Public"
    managed = "Terraform"
  }
}

resource "aws_route" "pubic" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_cloud.id
  tags = {
    Name    = "ECS App Private"
    managed = "Terraform"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}
