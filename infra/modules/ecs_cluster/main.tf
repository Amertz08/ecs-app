resource "aws_launch_template" "main" {
  name          = "${var.name}-lt"
  instance_type = var.instance_type
  image_id      = "ami-091aa67fccd794d5f"

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
    id = aws_launch_template.main.id
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = var.name
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
