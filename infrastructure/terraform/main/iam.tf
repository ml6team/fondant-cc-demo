resource "google_project_iam_member" "user_roles" {
  for_each = toset(var.user_roles)
  role     = each.key
  project  = var.project
  member   = "group:fondant@ml6.eu"
}

variable "user_roles" {
  description = "IAM roles to bind to users"
  type        = list(string)
  default = [
    "roles/container.clusterViewer",
    "roles/storage.admin",
    "roles/artifactregistry.repoAdmin",
    "roles/cloudbuild.builds.editor",
    "roles/serviceusage.serviceUsageConsumer",
    "roles/viewer"
  ]
}

resource "google_service_account_iam_member" "user_svc_user" {
  service_account_id = module.gke_cluster.service_account.id
  role               = "roles/iam.serviceAccountUser"
  member             = "group:fondant@ml6.eu"
}