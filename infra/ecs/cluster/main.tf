provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc_state" {
  backend = "local"
  config = {
    path = "${path.module}/../../vpc/terraform.tfstate"
  }
}

resource "aws_launch_template" "main" {
  name          = "ecs-app-lt"
  instance_type = "t2.micro"
  image_id      = "ami-091aa67fccd794d5f"

  tags = {
    Name    = "ECS App"
    managed = "Terraform"
  }
}

resource "aws_autoscaling_group" "main" {
  max_size            = 4
  min_size            = 0
  desired_capacity    = 0
  vpc_zone_identifier = data.terraform_remote_state.vpc_state.outputs.private_subnet_ids

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
    value               = "ecs-app"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "main" {
  name = "app-cap-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.main.arn
  }
}

resource "aws_ecs_cluster" "main" {
  name               = "ecs-app-cluster"
  capacity_providers = [aws_ecs_capacity_provider.main.name]
}
