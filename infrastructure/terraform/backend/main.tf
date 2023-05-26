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

/******************************************
	Google provider configuration
 *****************************************/

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

/******************************************
  State storage configuration
 *****************************************/

resource "google_storage_bucket" "terraform_state" {
  name                        = "${var.project}_terraform"
  location                    = var.region
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
