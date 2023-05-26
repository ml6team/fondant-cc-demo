
/******************************************
	Remote backend configuration
 *****************************************/

# setup of the backend gcs bucket that will keep the remote state

terraform {
  backend "gcs" {
    bucket = "boreal-array-387713_terraform"
    prefix = "terraform/state"
  }
}
