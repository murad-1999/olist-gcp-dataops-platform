provider "google" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source = "../../modules/storage"

  bucket_name                            = var.raw_bucket_name
  project_id                             = var.project_id
  location                               = var.region
  storage_class                          = "STANDARD"
  versioning_enabled                     = true
  noncurrent_version_retention_days      = var.noncurrent_version_retention_days
  abort_incomplete_multipart_upload_days = 7
  force_destroy                          = var.force_destroy

  labels = {
    environment = var.environment
  }
}

module "bigquery" {
  source = "../../modules/bigquery"

  project_id                 = var.project_id
  location                   = var.region
  silver_dataset_id          = var.silver_dataset_id
  gold_dataset_id            = var.gold_dataset_id
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = {
    environment = var.environment
  }
}
