resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for Olist dataops containers"
  format        = "DOCKER"
  project       = var.project_id

  # Ensure clean up of older versions for Free Tier Limits
  cleanup_policies {
    id     = "keep-recent"
    action = "KEEP"
    most_recent_versions {
      keep_count = 3
    }
  }
}

output "repository_name" {
  value = google_artifact_registry_repository.docker_repo.name
}
