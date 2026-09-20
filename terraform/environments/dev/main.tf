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
  raw_bucket_name            = var.raw_bucket_name
  silver_dataset_id          = var.silver_dataset_id
  gold_dataset_id            = var.gold_dataset_id
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = {
    environment = var.environment
  }
}

module "iam" {
  source      = "../../modules/iam"
  project_id  = var.project_id
  github_repo = var.github_repo
}

module "iam_secrets" {
  source             = "../../modules/iam_secrets"
  project_id         = var.project_id
  cloud_run_sa_email = module.iam.cloud_run_sa_email
}

module "artifact_registry" {
  source        = "../../modules/artifact_registry"
  project_id    = var.project_id
  region        = var.region
  repository_id = "olist-dataops-repo"
}

module "cloud_run" {
  source                = "../../modules/cloud_run"
  project_id            = var.project_id
  region                = var.region
  service_account_email = module.iam.cloud_run_sa_email
  image                 = var.docker_image
  secret_id             = module.iam_secrets.secret_id
  bucket_name           = var.raw_bucket_name
}

module "cloud_scheduler" {
  source                = "../../modules/cloud_scheduler"
  project_id            = var.project_id
  region                = var.region
  service_uri           = module.cloud_run.service_uri
  service_account_email = module.iam.scheduler_sa_email
}
