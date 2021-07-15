provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc_state" {
  backend = "local"
  config = {
    path = "${path.module}/../../vpc/terraform.tfstate"
  }
}

module "ecs-app-cluster" {
  source              = "../../modules/ecs_cluster"
  name                = "apps"
  desired_capacity    = 0
  min_size            = 0
  max_size            = 4
  instance_type       = "t2.micro"
  key_name            = "adam-mbp"
  vpc_zone_identifier = data.terraform_remote_state.vpc_state.outputs.private_subnet_ids
}
