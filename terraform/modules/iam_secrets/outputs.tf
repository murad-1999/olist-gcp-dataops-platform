output "secret_id" {
  value       = google_secret_manager_secret.kaggle_api_key.secret_id
  description = "The ID of the Secret Manager secret"
}
