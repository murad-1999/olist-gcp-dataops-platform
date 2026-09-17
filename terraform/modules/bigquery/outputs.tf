output "silver_dataset_id" {
  description = "The dataset ID of the provisioned Silver layer BigQuery dataset."
  value       = google_bigquery_dataset.silver.dataset_id
}

output "silver_dataset_self_link" {
  description = "The URI of the Silver layer BigQuery dataset."
  value       = google_bigquery_dataset.silver.self_link
}

output "gold_dataset_id" {
  description = "The dataset ID of the provisioned Gold layer BigQuery dataset."
  value       = google_bigquery_dataset.gold.dataset_id
}

output "gold_dataset_self_link" {
  description = "The URI of the Gold layer BigQuery dataset."
  value       = google_bigquery_dataset.gold.self_link
}
