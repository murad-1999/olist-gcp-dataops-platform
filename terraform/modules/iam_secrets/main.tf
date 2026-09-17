resource "google_secret_manager_secret" "kaggle_api_key" {
  project   = var.project_id
  secret_id = var.secret_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "cloud_run_access" {
  project   = google_secret_manager_secret.kaggle_api_key.project
  secret_id = google_secret_manager_secret.kaggle_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.cloud_run_sa_email}"
}
