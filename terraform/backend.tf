terraform {
  backend "gcs" {
    # Bucket is injected dynamically via -backend-config or backend.hcl to avoid hardcoding project IDs
    prefix = "terraform/state"
  }
}

