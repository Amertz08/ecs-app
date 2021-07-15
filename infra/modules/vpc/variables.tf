variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_cidr_blocks" {
  type        = list(string)
  description = "List of public subnets"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "List of private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs"
}

variable "enable_nat" {
  type        = bool
  default     = true
  description = "Turn ON/OFF NAT Gateways"
}