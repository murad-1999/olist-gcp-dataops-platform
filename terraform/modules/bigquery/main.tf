terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_bigquery_dataset" "silver" {
  dataset_id                 = var.silver_dataset_id
  friendly_name              = "Olist Silver"
  description                = var.silver_dataset_description
  location                   = var.location
  project                    = var.project_id
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = merge(
    var.labels,
    {
      data_layer = "silver"
      managed_by = "terraform"
    }
  )
}

resource "google_bigquery_dataset" "gold" {
  dataset_id                 = var.gold_dataset_id
  friendly_name              = "Olist Gold"
  description                = var.gold_dataset_description
  location                   = var.location
  project                    = var.project_id
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = merge(
    var.labels,
    {
      data_layer = "gold"
      managed_by = "terraform"
    }
  )
}
