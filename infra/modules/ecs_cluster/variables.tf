variable "name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "List of VPC Zones"
}

variable "min_size" {
  type        = number
  description = "MIN ASG size"
}

variable "max_size" {
  type        = number
  description = "MAX ASG size"
}

variable "desired_capacity" {
  type        = number
  description = "Desired ASG capacity"
}

variable "instance_type" {
  type        = string
  description = "Launch template instance type"
}

variable "key_name" {
  type        = string
  description = "Key to use for instances"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups to apply"
}

variable "asg_tags" {
  type        = list(map(string))
  default     = []
  description = "List of tags to apply to ASG"
}
