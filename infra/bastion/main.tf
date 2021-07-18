terraform {
  required_version = ">=0.12.18"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/bastion/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/vpc/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}

variable "bastion_instance_count" {
  type    = number
  default = 0
}

module "bastion_asg" {
  source   = "../modules/asg"
  name     = "bastion"
  image_id = "ami-0dc2d3e4c0f9ebd18"

  is_public           = true
  instance_type       = "t2.micro"
  key_name            = "adam-mbp"
  desired_capacity    = var.bastion_instance_count
  min_size            = var.bastion_instance_count
  max_size            = 4
  ssh_cidr_blocks     = ["0.0.0.0/0"]
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}
