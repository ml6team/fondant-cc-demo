output "endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.gke-cluster.endpoint
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  sensitive   = true
  value       = module.gke-cluster.ca_certificate
}
