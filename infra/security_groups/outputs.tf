output "public_instance_sg_id" {
  value = aws_security_group.public_instance.id
}

output "ssh_self_sg_id" {
  value = aws_security_group.ssh_self.id
}
