output "bucket_name" {
  description = "The name of the provisioned GCS raw landing bucket."
  value       = google_storage_bucket.raw_landing.name
}

output "bucket_url" {
  description = "The gs:// URI of the provisioned GCS raw landing bucket."
  value       = "gs://${google_storage_bucket.raw_landing.name}"
}

output "bucket_id" {
  description = "The ID of the provisioned GCS raw landing bucket."
  value       = google_storage_bucket.raw_landing.id
}

output "bucket_self_link" {
  description = "The URI of the created resource."
  value       = google_storage_bucket.raw_landing.self_link
}
