variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "secret_id" {
  type        = string
  description = "The ID of the secret to create"
  default     = "kaggle_api_key"
}

variable "cloud_run_sa_email" {
  type        = string
  description = "Service account email for Cloud Run to access the secret"
}
