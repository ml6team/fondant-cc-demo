output "network_name" {
  value       = module.vpc-network.network_name
  description = "Network name"
}

output "subnets_names" {
  value       = module.vpc-network.subnets_names
  description = "Subnet name"
}

output "subnets_secondary_ranges" {
  value       = module.vpc-network.subnets_secondary_ranges[0][*].range_name
  description = "Subnet secondary ranges"
}
