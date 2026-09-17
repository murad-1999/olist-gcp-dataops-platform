variable "project_id" {
  description = "The GCP Project ID where resources will be provisioned."
  type        = string
}

variable "region" {
  description = "The GCP region for resource deployment. Defaults to us-central1 to ensure Always Free tier colocation."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "The deployment environment name (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "raw_bucket_name" {
  description = "Globally unique name for the raw GCS landing bucket (Bronze layer)."
  type        = string
}

variable "silver_dataset_id" {
  description = "Dataset ID for the staging/cleaned data (Silver layer)."
  type        = string
  default     = "olist_silver"
}

variable "gold_dataset_id" {
  description = "Dataset ID for the analytics/star schema marts (Gold layer)."
  type        = string
  default     = "olist_gold"
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent versions in the raw landing bucket to prevent exceeding Always Free 5 GB quota."
  type        = number
  default     = 7
}

variable "force_destroy" {
  description = "Whether to allow destruction of non-empty GCS bucket upon terraform destroy."
  type        = bool
  default     = false
}

variable "delete_contents_on_destroy" {
  description = "Whether to allow destruction of non-empty BigQuery datasets upon terraform destroy."
  type        = bool
  default     = false
}
