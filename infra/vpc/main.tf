terraform {
  required_version = ">=0.12.18"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "ecs-app/vpc/terraform.tfstate"
    bucket  = "tf-state-personal-projects"
  }
}

variable "enable_nat" {
  default = false
}

module "ecs_app" {
  source     = "../modules/vpc"
  name       = "ecs-app"
  enable_nat = var.enable_nat

  cidr_block          = "10.0.0.0/16"
  public_cidr_blocks  = ["10.0.0.0/24", "10.0.2.0/24"]
  private_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
}

output "private_subnet_ids" {
  value = module.ecs_app.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.ecs_app.public_subnet_ids
}

output "public_subnet_cidr_blocks" {
  value = module.ecs_app.public_subnet_cidr_blocks
}

output "vpc_id" {
  value = module.ecs_app.vpc_id
}
