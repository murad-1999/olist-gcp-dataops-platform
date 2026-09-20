resource "google_cloud_run_v2_service" "ingestion" {
  name     = "olist-ingestion-service"
  location = var.region
  project  = var.project_id

  template {
    service_account = var.service_account_email
    containers {
      image = var.image
      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "SECRET_ID"
        value = var.secret_id
      }
      env {
        name  = "BUCKET_NAME"
        value = var.bucket_name
      }
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
        cpu_idle = true
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }
  }
}
