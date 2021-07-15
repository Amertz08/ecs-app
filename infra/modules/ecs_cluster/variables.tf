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
