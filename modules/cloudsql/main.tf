# PostgreSQL instance
resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  region           = var.region
  database_version = "POSTGRES_18"

  deletion_protection = var.deletion_protection

  settings {
    tier              = var.db_tier
    availability_type = var.availability_type

    disk_type       = var.disk_type
    disk_size       = var.disk_size
    disk_autoresize = true

    backup_configuration {
      enabled                        = var.backups_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = var.pitr_enabled
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}

# Database
resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

# IAM database user
locals {
  iam_db_user = trimsuffix(
    var.service_account_email,
    ".gserviceaccount.com"
  )
}

# IAM service account user
resource "google_sql_user" "iam_user" {
  instance = google_sql_database_instance.postgres.name
  name     = local.iam_db_user
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

# Read replica for load distribution (read-only app)
resource "google_sql_database_instance" "read_replica" {
  count            = var.enable_read_replica ? 1 : 0
  name             = "${var.instance_name}-replica"
  region           = var.region
  database_version = "POSTGRES_18"
  
  master_instance_name = google_sql_database_instance.postgres.name
  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL"

    disk_type       = var.disk_type
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}