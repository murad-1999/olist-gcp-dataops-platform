output "raw_bucket_name" {
  description = "The name of the provisioned GCS raw landing bucket (Bronze layer)."
  value       = module.storage.bucket_name
}

output "raw_bucket_url" {
  description = "The gs:// URI of the provisioned GCS raw landing bucket (Bronze layer)."
  value       = module.storage.bucket_url
}

output "silver_dataset_id" {
  description = "The dataset ID of the provisioned Silver layer BigQuery dataset."
  value       = module.bigquery.silver_dataset_id
}

output "gold_dataset_id" {
  description = "The dataset ID of the provisioned Gold layer BigQuery dataset."
  value       = module.bigquery.gold_dataset_id
}

output "workload_identity_provider_name" {
  description = "Workload Identity Provider resource name for GitHub Actions."
  value       = module.iam.workload_identity_provider_name
}

output "github_actions_sa_email" {
  description = "Service account email used by GitHub Actions."
  value       = module.iam.github_actions_sa_email
}

output "cloud_run_service_uri" {
  description = "The URI of the Cloud Run ingestion service."
  value       = module.cloud_run.service_uri
}
