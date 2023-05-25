variable "project" {
  description = "GCP project name"
  type        = string
}

variable "region" {
  description = "Default GCP region for resources"
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "subnetwork_name" {
  description = "Name of the subnetwork to be used by GKE nodes."
  type        = string
}

variable "subnetwork_ip_range" {
  description = "IPv4 CIDR block to be used by GKE nodes."
  type        = string
}

variable "ip_range_pods_name" {
  description = "Name of the secondary IP range to be used by GKE pods."
  type        = string
}

variable "ip_range_pods" {
  description = "IPv4 CIDR block to be used by GKE pods."
  type        = string
}

variable "ip_range_services_name" {
  description = "Name of the secondary IP range to be used by GKE services."
  type        = string
}

variable "ip_range_services" {
  description = "IPv4 CIDR block to be used by GKE services."
  type        = string
}

variable "vpc_connector" {
  description = "Whether or not to add a vpc_connector."
  type        = bool
}

variable "vpc_connector_ip_range" {
  description = "An unreserved /28 internal IP range used by the VPC connector"
  type        = string
  default     = "10.8.0.0/28"
}
