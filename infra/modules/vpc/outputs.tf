output "private_subnet_ids" {
  value = [for net in aws_subnet.private : net.id]
}

output "public_subnet_cidr_blocks" {
  value = [for net in aws_subnet.public : net.cidr_block]
}
