module "ecs_asg" {
  source   = "../asg"
  name     = var.name
  key_name = var.key_name
  image_id = "ami-091aa67fccd794d5f"

  ssh_cidr_blocks     = var.public_subnet_cidr_blocks
  desired_capacity    = var.desired_capacity
  instance_type       = var.instance_type
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_id              = var.vpc_id
  vpc_zone_identifier = var.vpc_zone_identifier
  asg_tags = concat(var.asg_tags, [{
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }])
  instance_role_name = aws_iam_role.main.name
}

resource "aws_ecs_capacity_provider" "main" {
  name = "${var.name}-cap-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = module.ecs_asg.asg_arn
  }
}

resource "aws_ecs_cluster" "main" {
  name               = "${var.name}-cluster"
  capacity_providers = [aws_ecs_capacity_provider.main.name]
}

resource "aws_iam_role" "main" {
  name               = "${var.name}-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "instance_ecs" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
