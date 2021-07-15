resource "aws_security_group" "instance_sg" {
  name_prefix = "${var.name}-sg-"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name}-instance-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.instance_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.public_subnet_cidr_blocks
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instance_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_launch_template" "main" {
  name                   = "${var.name}-lt"
  instance_type          = var.instance_type
  image_id               = "ami-091aa67fccd794d5f"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name    = var.name
    managed = "Terraform"
  }
}

resource "aws_autoscaling_group" "main" {
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.name}-cluster"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "main" {
  name = "${var.name}-cap-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.main.arn
  }
}

resource "aws_ecs_cluster" "main" {
  name               = "${var.name}-cluster"
  capacity_providers = [aws_ecs_capacity_provider.main.name]
}
