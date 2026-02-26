# Cloud Run service
resource "google_cloud_run_v2_service" "service" {
  name     = var.app_name
  location = var.region

  lifecycle {
    ignore_changes = [template]
  }
  template {
    service_account = var.service_account_email

    containers {
      image = var.image

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      # Optional env vars
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    # VPC Access for Cloud SQL Private IP
    dynamic "vpc_access" {
      for_each = var.connector_id != null ? [1] : []
      content {
        connector = var.connector_id
        egress    = var.vpc_egress
      }
    }

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  ingress = var.ingress
}

# Public access IAM binding
resource "google_cloud_run_service_iam_member" "invoker" {
  count = var.allow_public_access ? 1 : 0

  location = var.region
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}