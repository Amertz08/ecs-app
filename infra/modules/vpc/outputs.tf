output "private_subnet_ids" {
  value = [for net in aws_subnet.private : net.id]
}
