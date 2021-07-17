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
  cidr_blocks       = var.ssh_cidr_blocks
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instance_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
  from_port         = var.ingress_rules[count.index].from_port
  protocol          = var.ingress_rules[count.index].protocol
  to_port           = var.ingress_rules[count.index].to_port
  //  cidr_blocks       = lookup(var.ingress_rules[count.index], "cidr_blocks", var.default_list)
  description = lookup(var.ingress_rules[count.index], "description", "")
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.name}-instance-profile"
  role = var.instance_role_name
}

resource "aws_launch_template" "main" {
  name                   = "${var.name}-lt"
  instance_type          = var.instance_type
  image_id               = var.image_id
  key_name               = var.key_name
  update_default_version = true
  ebs_optimized          = var.ebs_optimized
  user_data              = base64encode(var.user_data)

  monitoring {
    enabled = var.monitoring_enabled
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }

  network_interfaces {
    associate_public_ip_address = var.is_public
    security_groups             = [aws_security_group.instance_sg.id]
  }

  tags = {
    Name    = var.name
    managed = "Terraform"
  }
}

resource "aws_autoscaling_group" "main" {
  name                = "${var.name}-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  tags = concat([
    {
      key                 = "Name"
      value               = "${var.name}-cluster"
      propagate_at_launch = true
    }
  ], var.asg_tags)
}
