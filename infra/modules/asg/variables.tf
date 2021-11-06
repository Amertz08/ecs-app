variable "name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "instance_role_name" {
  type        = string
  default     = ""
  description = "IAM role name for instances"
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

variable "is_public" {
  type        = bool
  default     = false
  description = "Whether or not to associate a public IP"
}

variable "asg_tags" {
  type        = list(map(string))
  default     = []
  description = "Tags to add to ASG"
}

variable "ebs_optimized" {
  type        = bool
  default     = false
  description = "EBS optimization flag"
}

variable "monitoring_enabled" {
  type        = bool
  default     = false
  description = "Instance monitoring flag"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User data to send to instance"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "Security groups to add to ASG launch template"
}
