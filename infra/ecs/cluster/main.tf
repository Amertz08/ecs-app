data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/vpc/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/security_groups/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}

variable "cluster_instance_count" {
  type    = number
  default = 0
}

module "ecs-app-cluster" {

  source              = "../../modules/ecs_cluster"
  name                = "apps"
  desired_capacity    = var.cluster_instance_count
  min_size            = var.cluster_instance_count
  max_size            = 4
  instance_type       = "t2.micro"
  key_name            = "adam-mbp"
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.ssh_self_sg_id
  ]
}

output "cluster_arn" {
  value = module.ecs-app-cluster.cluster_arn
}

output "capacity_provider_name" {
  value = module.ecs-app-cluster.capacity_provider_name
}
