variable "project_id" {
  description = "The GCP project ID where the datasets will be created. Defaults to provider project if null."
  type        = string
  default     = null
}

variable "location" {
  description = "The geographic location where the datasets should reside. Defaults to us-central1 for Always Free tier colocation."
  type        = string
  default     = "us-central1"
}

variable "bronze_dataset_id" {
  description = "Unique dataset ID for the raw landing data (Bronze layer)."
  type        = string
  default     = "olist_bronze"
}

variable "raw_bucket_name" {
  description = "The name of the raw GCS bucket containing ingested CSVs."
  type        = string
}

variable "silver_dataset_id" {
  description = "Unique dataset ID for the staging/cleaned data (Silver layer)."
  type        = string
  default     = "olist_silver"
}

variable "silver_dataset_description" {
  description = "Description for the Silver layer BigQuery dataset."
  type        = string
  default     = "Olist staging and cleaned data (Silver layer)"
}

variable "gold_dataset_id" {
  description = "Unique dataset ID for the analytics/star schema marts (Gold layer)."
  type        = string
  default     = "olist_gold"
}

variable "gold_dataset_description" {
  description = "Description for the Gold layer BigQuery dataset."
  type        = string
  default     = "Olist analytics and dimensional star schema marts (Gold layer)"
}

variable "delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Key-value labels to assign to the datasets."
  type        = map(string)
  default     = {}
}
