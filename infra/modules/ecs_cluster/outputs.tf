output "cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.main.name
}
