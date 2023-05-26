resource "google_project_service" "compute" {
  project                    = var.project
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false
}

module "vpc-network" {
  source  = "terraform-google-modules/network/google"
  version = "5.1.0"

  project_id   = var.project
  network_name = var.network_name

  description = "Custom network created with Nimbus"

  subnets = [
    {
      subnet_name           = var.subnetwork_name
      subnet_ip             = var.subnetwork_ip_range
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    (var.subnetwork_name) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_range_pods
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_range_services
      }
    ]
  }

  depends_on = [google_project_service.compute]
}

resource "google_compute_router" "default" {
  name    = "nat-router-${var.region}"
  region  = var.region
  network = module.vpc-network.network_name

}

resource "google_compute_router_nat" "default" {
  name                               = "nat-config-${var.region}"
  router                             = google_compute_router.default.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow-ssh-from-iap" {
  name    = "allow-ssh-from-iap"
  network = module.vpc-network.network_name
  project = var.project

  source_ranges = [
    "35.235.240.0/20",
  ]

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }
}

resource "google_vpc_access_connector" "connector" {
  count          = var.vpc_connector ? 1 : 0
  name           = var.subnetwork_name
  region         = var.region
  ip_cidr_range  = var.vpc_connector_ip_range
  network        = module.vpc-network.network_name
  min_throughput = 200
  max_throughput = 300

  depends_on = [
    google_project_service.vpcaccess
  ]
}

resource "google_project_service" "vpcaccess" {
  count   = var.vpc_connector ? 1 : 0
  project = var.project
  service = "vpcaccess.googleapis.com"
}
