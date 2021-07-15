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
  source                    = "../../modules/ecs_cluster"
  name                      = "apps"
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 4
  instance_type             = "t2.micro"
  key_name                  = "adam-mbp"
  vpc_id                    = data.terraform_remote_state.vpc_state.outputs.vpc_id
  vpc_zone_identifier       = data.terraform_remote_state.vpc_state.outputs.private_subnet_ids
  public_subnet_cidr_blocks = data.terraform_remote_state.vpc_state.outputs.public_subnet_cidr_blocks
}
