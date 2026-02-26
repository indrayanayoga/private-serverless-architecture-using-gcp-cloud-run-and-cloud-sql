output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.postgres.name
}

output "private_ip" {
  description = "Private IP address"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "connection_name" {
  description = "Connection name"
  value       = google_sql_database_instance.postgres.connection_name
}

output "replica_private_ip" {
  description = "Read replica private IP address"
  value       = var.enable_read_replica ? google_sql_database_instance.read_replica[0].private_ip_address : null
}

output "replica_connection_name" {
  description = "Read replica connection name"
  value       = var.enable_read_replica ? google_sql_database_instance.read_replica[0].connection_name : null
}