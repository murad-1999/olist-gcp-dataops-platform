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
