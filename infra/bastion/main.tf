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

data aws_ssm_parameter "amz_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"
}

variable "bastion_instance_count" {
  type    = number
  default = 0
}

module "bastion_asg" {
  source   = "../modules/asg"
  name     = "bastion"
  image_id = data.aws_ssm_parameter.amz_linux_ami.value

  is_public        = true
  instance_type    = "t2.micro"
  key_name         = "adam-mbp"
  desired_capacity = var.bastion_instance_count
  min_size         = var.bastion_instance_count
  max_size         = 4
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.public_instance_sg_id,
    data.terraform_remote_state.security_groups.outputs.ssh_self_sg_id
  ]
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}
