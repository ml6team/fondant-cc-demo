resource "google_project_service" "artifactregistry" {
  project = var.project
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "docker_artifact" {
  provider      = google-beta
  location      = var.region
  project       = var.project
  repository_id = "${var.project}-default-repository"
  format        = "DOCKER"

  depends_on = [google_project_service.artifactregistry]
}

resource "google_artifact_registry_repository" "kfp_template_artifact" {
  location      = var.region
  project       = var.project
  repository_id = "${var.project}-kfp-template-repository"
  format        = "KFP"

  depends_on = [google_project_service.artifactregistry]
}
