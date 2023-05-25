/******************************************
	Resources
 *****************************************/

resource "google_project_service" "container" {
  project = var.project
  service = "container.googleapis.com"
}

resource "google_project_service" "containerregistry" {
  project            = var.project
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
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

/******************************************
	GSA and bucket access
 *****************************************/

# create user GSA
resource "google_service_account" "kfp-pipeline-user" {
  project     = var.project
  account_id  = "svc-kfp-user"
  description = "Service account for the KFP pipelines"
}


# set roles
resource "google_project_iam_member" "kfp_pipeline_roles" {
  for_each = toset(var.kfp_pipeline_roles)
  role     = each.key
  project  = var.project
  member   = "serviceAccount:${google_service_account.kfp-pipeline-user.email}"
}


variable "kfp_pipeline_roles" {
  description = "IAM roles to bind on service account"
  type        = list(string)
  default = [
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
    "roles/cloudsql.client"
  ]
}

resource "google_storage_bucket" "datasets" {
  name                        = "${var.project}_datasets"
  location                    = var.region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}


resource "google_storage_bucket" "models" {
  name                        = "${var.project}_models"
  location                    = var.region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "kfp-artifacts" {
  name                        = "${var.project}_kfp-artifacts"
  location                    = var.region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_binding" "dataset_binding" {
  bucket = google_storage_bucket.datasets.name

  members = [
    "serviceAccount:${google_service_account.kfp-pipeline-user.email}"
  ]

  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_binding" "models_binding" {
  bucket = google_storage_bucket.models.name

  members = [
    "serviceAccount:${google_service_account.kfp-pipeline-user.email}"
  ]

  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_binding" "artifact_binding" {
  bucket = google_storage_bucket.kfp-artifacts.name

  members = [
    "serviceAccount:${google_service_account.kfp-pipeline-user.email}"
  ]

  role = "roles/storage.objectAdmin"
}

/******************************************
	Cluster
 *****************************************/

module "gke-cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "24.0.0"

  project_id      = google_project_service.container.project
  name            = var.cluster_name
  region          = var.region
  regional        = false
  zones           = [var.zone]
  release_channel = "STABLE"

  network                    = var.network_name
  subnetwork                 = var.subnetwork_name
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  service_account            = google_service_account.kfp-pipeline-user.email
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  enable_private_nodes       = true
  master_authorized_networks = var.master_authorized_networks
  grant_registry_access      = true
  remove_default_node_pool   = true
  network_policy             = true
  maintenance_start_time     = "00:00"
  identity_namespace         = ""
  node_metadata              = "UNSPECIFIED"


  node_pools = [
    for node_pool_spec in var.node_pools :
    {
      name                      = node_pool_spec.name
      machine_type              = node_pool_spec.machine_type
      disk_size_gb              = node_pool_spec.disk_size
      disk_type                 = node_pool_spec.disk_type
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      preemptible               = node_pool_spec.preemptible
      node_count                = node_pool_spec.node_count
      autoscaling               = node_pool_spec.autoscaling
      min_count                 = node_pool_spec.min_count
      max_count                 = node_pool_spec.max_count
      accelerator_type          = node_pool_spec.accelerator_type
      accelerator_count         = node_pool_spec.accelerator_count
      local_ssd_ephemeral_count = node_pool_spec.local_ssd_ephemeral_count #375 Gb per ssd
    }
  ]

  node_pools_taints = var.node_pools_taints

}
