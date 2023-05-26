/******************************************
	Google provider configuration
 *****************************************/

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

/******************************************
	Variables
 *****************************************/

variable "project" {
  description = "GCP project name"
  type        = string
}

variable "region" {
  description = "Default GCP region for resources"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Default GCP zone for resources"
  type        = string
  default     = "europe-west1-b"
}

locals {
  network_name    = "main-network"
  subnetwork_name = var.region
}

/******************************************
	        VPC configuration
 *****************************************/

module "vpc-network" {
  source                 = "../modules/vpc"
  project                = var.project
  region                 = var.region
  network_name           = local.network_name
  subnetwork_name        = local.subnetwork_name
  subnetwork_ip_range    = "10.10.10.0/24"
  ip_range_pods          = "10.28.0.0/16"
  ip_range_pods_name     = "${local.subnetwork_name}-gke-pods"
  ip_range_services      = "10.0.0.0/20"
  ip_range_services_name = "${local.subnetwork_name}-gke-services"
  vpc_connector          = "true"
}
