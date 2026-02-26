terraform {
  required_version = ">= 1.5"

  backend "gcs" {
    bucket  = "central-project-terraform-states"
    prefix  = "projects/myapp/prod/terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required GCP APIs
resource "google_project_service" "required" {
  for_each = toset([
    "compute.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ])
  service = each.value
}

# Service account for Cloud Run and Cloud SQL
resource "google_service_account" "my_sa" {
  account_id   = var.service_account_name
  display_name = "${var.app_name} Service Account"
}

# IAM roles for service account
resource "google_project_iam_member" "sa_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/cloudsql.instanceUser",
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.my_sa.email}"
}

# Docker artifact registry
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.app_name
  description   = "Docker repo for ${var.app_name}"
  format        = "DOCKER"
}

# Cloud Armor security policy
module "security" {
  source   = "../../modules/security"
  app_name = var.app_name
  
  rate_limit_requests = var.rate_limit_requests
  ban_duration_sec    = var.ban_duration_sec
}

# VPC network and connectivity
module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  region     = var.region
  vpc_name   = var.vpc_name

  subnets = {}

  enable_psa        = var.enable_psa
  psa_range_name    = var.psa_range_name
  psa_prefix_length = var.psa_prefix_length

  enable_connector = var.enable_connector
  connector_cidr   = var.connector_cidr
  app_name         = var.app_name
}

# PostgreSQL database
module "cloudsql" {
  source = "../../modules/cloudsql"

  region                = var.region
  instance_name         = var.instance_name
  db_name               = var.db_name
  db_tier               = var.db_tier
  disk_size             = var.disk_size
  availability_type     = var.availability_type
  deletion_protection   = var.deletion_protection
  backups_enabled       = var.backups_enabled
  pitr_enabled          = var.pitr_enabled
  vpc_id                = module.network.vpc_id
  service_account_email = google_service_account.my_sa.email
  enable_read_replica   = var.enable_read_replica

  depends_on = [
    module.network
  ]
}

# Cloud Run service
module "cloudrun" {
  source = "../../modules/cloudrun"

  app_name              = var.app_name
  region                = var.region
  image                 = var.cloud_run_image
  service_account_email = google_service_account.my_sa.email
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  cpu                   = var.cpu
  memory                = var.memory

  connector_id = module.network.connector_id

  env_vars = {
    DB_HOST = module.cloudsql.private_ip
    DB_NAME = var.db_name
  }

  allow_public_access = false  # since LB will front it
}

# Load balancer with SSL
module "loadbalancing" {
  source = "../../modules/loadbalancing"
  project_id             = var.project_id
  app_name               = var.app_name
  region                 = var.region
  domain                 = var.domain
  ssl_certificate_name   = var.ssl_certificate_name
  cloud_run_service_name = module.cloudrun.service_name

  security_policy_id = module.security.security_policy_id
}