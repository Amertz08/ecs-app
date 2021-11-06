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
    security_groups             = var.security_groups
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
