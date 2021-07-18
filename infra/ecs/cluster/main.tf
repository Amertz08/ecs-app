data "terraform_remote_state" "vpc_state" {
  backend = "local"
  config = {
    path = "${path.module}/../../vpc/terraform.tfstate"
  }
}

variable "cluster_instance_count" {
  type    = number
  default = 0
}

module "ecs-app-cluster" {

  source                    = "../../modules/ecs_cluster"
  name                      = "apps"
  desired_capacity          = var.cluster_instance_count
  min_size                  = var.cluster_instance_count
  max_size                  = 4
  instance_type             = "t2.micro"
  key_name                  = "adam-mbp"
  vpc_id                    = data.terraform_remote_state.vpc_state.outputs.vpc_id
  vpc_zone_identifier       = data.terraform_remote_state.vpc_state.outputs.private_subnet_ids
  public_subnet_cidr_blocks = data.terraform_remote_state.vpc_state.outputs.public_subnet_cidr_blocks
}

output "cluster_arn" {
  value = module.ecs-app-cluster.cluster_arn
}

output "capacity_provider_name" {
  value = module.ecs-app-cluster.capacity_provider_name
}
