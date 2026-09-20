resource "google_cloud_scheduler_job" "daily_ingestion" {
  name        = "olist-daily-ingestion"
  description = "Trigger daily data ingestion to Cloud Run"
  schedule    = "0 2 * * *" # Run at 2 AM every day
  time_zone   = "UTC"
  project     = var.project_id
  region      = var.region

  http_target {
    http_method = "POST"
    uri         = var.service_uri

    oidc_token {
      service_account_email = var.service_account_email
    }
  }
}
