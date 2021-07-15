variable "name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "image_id" {
  type        = string
  default     = "ami-0dc2d3e4c0f9ebd18"
  description = "AWS Image ID"
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

variable "vpc_id" {
  type        = string
  description = "VPC ID for security groups"
}

variable "ssh_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for the SG"
}

variable "is_public" {
  type        = bool
  default     = false
  description = "Whether or not to associate a public IP"
}
