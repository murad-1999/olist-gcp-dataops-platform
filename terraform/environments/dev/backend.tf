terraform {
  backend "gcs" {
    # Prefix isolates state per environment
    # Bucket is injected dynamically via -backend-config or backend.hcl to avoid hardcoding project IDs
    prefix = "terraform/state/dev"
  }
}

