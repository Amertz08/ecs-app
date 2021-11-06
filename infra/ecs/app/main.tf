data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/ecs/cluster/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}


resource "aws_ecs_task_definition" "app" {
  family = "flask-app"
  container_definitions = jsonencode([
    {
      cpu : 256,
      essential : true,
      image : "vad1mo/hello-world-rest:latest",
      memoryReservation : 128,
      name : "hello-world"
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "flask-app"
  cluster         = data.terraform_remote_state.cluster.outputs.cluster_arn
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  capacity_provider_strategy {
    capacity_provider = data.terraform_remote_state.cluster.outputs.capacity_provider_name
    weight            = "50"
    base              = "2"
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition, health_check_grace_period_seconds]
  }
}
