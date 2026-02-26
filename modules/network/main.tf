# VPC network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks  = false
}

# Subnets
resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets
  name          = each.key
  ip_cidr_range = each.value.cidr
  region        = each.value.region
  network       = google_compute_network.vpc.id
}

# Private Service Access IP range
resource "google_compute_global_address" "psa_range" {
  count         = var.enable_psa ? 1 : 0
  name          = var.psa_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_prefix_length
  network       = google_compute_network.vpc.id
}

# Private Service Access connection
resource "google_service_networking_connection" "psa_connection" {
  count                   = var.enable_psa ? 1 : 0
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range[0].name]
}

# Serverless VPC connector
resource "google_vpc_access_connector" "connector" {
  count         = var.enable_connector ? 1 : 0
  name          = "${var.app_name}-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.connector_cidr
}