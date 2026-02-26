output "vpc_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "subnets" {
  description = "Subnet IDs"
  value = {
    for k, s in google_compute_subnetwork.subnets :
    k => s.id
  }
}

output "psa_connection" {
  description = "PSA connection ID"
  value       = var.enable_psa ? google_service_networking_connection.psa_connection[0].id : null
}

output "connector_id" {
  description = "VPC connector ID"
  value       = var.enable_connector ? google_vpc_access_connector.connector[0].id : null
}