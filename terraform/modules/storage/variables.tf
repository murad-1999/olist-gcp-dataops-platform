variable "bucket_name" {
  description = "The globally unique name of the raw GCS landing bucket."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the bucket will be created. Defaults to provider project if null."
  type        = string
  default     = null
}

variable "location" {
  description = "The GCP region for the bucket. Defaults to us-central1 for Always Free tier colocation."
  type        = string
  default     = "us-central1"
}

variable "storage_class" {
  description = "The storage class of the bucket. Defaults to STANDARD (Free tier eligible)."
  type        = string
  default     = "STANDARD"
}

variable "versioning_enabled" {
  description = "Whether versioning is enabled for the raw landing bucket."
  type        = bool
  default     = true
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent (archived) object versions before automated deletion."
  type        = number
  default     = 7
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Number of days after which incomplete multipart uploads are automatically aborted."
  type        = number
  default     = 7
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Key-value labels to assign to the bucket."
  type        = map(string)
  default     = {}
}
