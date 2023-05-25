variable "project" {
  description = "GCP project name"
  type        = string
}

variable "region" {
  description = "Default GCP region for resources"
  type        = string
  default     = "europe-west4"
}

variable "zone" {
  description = "Default GCP zone for resources"
  type        = string
  default     = "europe-west4-a"
}

variable "cluster_name" {
  description = "GKE cluster name."
  type        = string
}

variable "master_authorized_networks" {
  description = "IPv4 CIDR blocks that are authorized to connect to cluster master."
  type        = list(object({ cidr_block = string, display_name = string }))
}

variable "ip_range_pods_name" {
  description = "Name of the secondary IP range to be used by GKE pods."
  type        = string
}

variable "ip_range_services_name" {
  description = "Name of the secondary IP range to be used by GKE services."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "IPv4 CIDR block to be used by cluster master."
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "subnetwork_name" {
  description = "Name of the subnetwork to be used by GKE nodes."
  type        = string
}

variable "node_pools" {
  description = "List of specs for GKE node pools to be created in the cluster."
  type        = list(map(string))
}

variable "node_pools_taints" {
  description = "List of maps, each representing a node pool taint"
  type        = map(list(object({ key = string, value = string, effect = string })))
  default     = {}
}
