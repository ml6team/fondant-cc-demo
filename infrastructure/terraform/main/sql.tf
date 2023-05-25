/******************************************
	        VPC Peering configuration
 *****************************************/

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc-network.network_name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc-network.network_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

/******************************************
	        database configuration
 *****************************************/

resource "google_sql_database_instance" "metadata-database" {
  name                = "kfp-metadata"
  database_version    = "MYSQL_5_7"
  region              = var.region
  deletion_protection = true
  depends_on          = [google_service_networking_connection.private_vpc_connection]

  # Be careful here as the disk size can automatically increase which can cause Terraform to delete
  # the database if the disk_size specified is smaller than the resized amount
  settings {
    tier            = "db-n1-standard-1"
    disk_size       = 50
    disk_type       = "PD_SSD"
    disk_autoresize = false

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project}/global/networks/main-network"
    }
    backup_configuration {
      enabled    = true
      location   = "eu"
      start_time = "00:00"
    }
  }
}

/******************************************
	        Default user configuration
 *****************************************/
# Store password in secret manager and create user

resource "google_secret_manager_secret" "sql-key" {
  secret_id = "sql-key"

  replication {
    automatic = true
  }
  depends_on = [google_project_service.gcp_services]
}

resource "random_password" "sql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_secret_manager_secret_version" "sql-key-1" {
  secret      = google_secret_manager_secret.sql-key.id
  secret_data = random_password.sql_password.result
  depends_on  = [google_secret_manager_secret.sql-key]
}

resource "google_sql_user" "sql-user" {
  name     = "root"
  instance = google_sql_database_instance.metadata-database.name
  password = google_secret_manager_secret_version.sql-key-1.secret_data
}