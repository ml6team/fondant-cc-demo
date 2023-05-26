/******************************************
	Variables
 *****************************************/

variable "master_authorized_networks" {
  description = "IPv4 CIDR blocks that are authorized to connect to cluster master."
  type        = list(object({ cidr_block = string, display_name = string }))
  default = [
    {
      cidr_block   = "81.245.5.156/32"
      display_name = "ML6-office-1"
    },
    {
      cidr_block   = "84.198.172.145/32"
      display_name = "ML6-office-2"
    },
    {
      cidr_block   = "81.245.214.29/32"
      display_name = "Philippe-home"
    },
    {
      cidr_block   = "109.130.56.145/32"
      display_name = "Robbe-home"
    },
    {
      cidr_block   = "178.117.11.246/32"
      display_name = "Niels-home"
    },
  ]
}

locals {
  node_pools = [
    {
      name         = "default-pool",
      machine_type = "n1-standard-2",
      disk_type    = "pd-standard",
      disk_size    = 100,
      autoscaling  = false,
      preemptible  = false,
      # standalone kfp takes at minimum 3 n1-standard-2 nodes
      node_count                = 3,
      min_count                 = 3,
      max_count                 = 3,
      accelerator_type          = "",
      accelerator_count         = 0,
      local_ssd_ephemeral_count = 0
    },
    {
      name         = "work-pool",
      machine_type = "n1-standard-2",
      disk_type    = "pd-standard",
      disk_size    = 100,
      autoscaling  = true,
      preemptible  = false,
      node_count                = 3,
      min_count                 = 0,
      max_count                 = 100,
      accelerator_type          = "",
      accelerator_count         = 0,
      local_ssd_ephemeral_count = 0
    },
  ]
}


/******************************************
	GKE configuration
 *****************************************/
module "gke_cluster" {
  source                     = "../modules/kubernetes"
  project                    = var.project
  zone                       = var.zone
  region                     = var.region
  node_pools                 = local.node_pools
  cluster_name               = "fondant-cluster"
  master_ipv4_cidr_block     = "172.16.0.0/28"
  master_authorized_networks = var.master_authorized_networks
  ip_range_pods_name         = module.vpc-network.subnets_secondary_ranges[0]
  ip_range_services_name     = module.vpc-network.subnets_secondary_ranges[1]
  network_name               = module.vpc-network.network_name
  subnetwork_name            = module.vpc-network.subnets_names[0]
}

resource "google_project_service" "iam_credentials" {
  project = var.project
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "iam" {
  project    = var.project
  service    = "iam.googleapis.com"
  depends_on = [google_project_service.iam_credentials]
}