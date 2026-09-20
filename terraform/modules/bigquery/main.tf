terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_bigquery_dataset" "bronze" {
  dataset_id                 = var.bronze_dataset_id
  friendly_name              = "Olist Bronze"
  description                = "Olist raw ingestion data (Bronze layer)"
  location                   = var.location
  project                    = var.project_id
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = merge(
    var.labels,
    {
      data_layer = "bronze"
      managed_by = "terraform"
    }
  )
}

resource "google_bigquery_table" "raw_orders" {
  dataset_id          = google_bigquery_dataset.bronze.dataset_id
  table_id            = "raw_orders"
  project             = var.project_id
  deletion_protection = false

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
    source_uris   = ["gs://${var.raw_bucket_name}/olist_orders_dataset.csv"]
    csv_options {
      quote                 = "\""
      allow_quoted_newlines = true
      skip_leading_rows     = 1
    }
  }
}

resource "google_bigquery_table" "raw_customers" {
  dataset_id          = google_bigquery_dataset.bronze.dataset_id
  table_id            = "raw_customers"
  project             = var.project_id
  deletion_protection = false

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
    source_uris   = ["gs://${var.raw_bucket_name}/olist_customers_dataset.csv"]
    csv_options {
      quote                 = "\""
      allow_quoted_newlines = true
      skip_leading_rows     = 1
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
