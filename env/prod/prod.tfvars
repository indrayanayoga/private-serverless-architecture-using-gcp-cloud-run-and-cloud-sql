# Core
project_id = "project-prod"
region     = "asia-southeast2"
app_name   = "myapp-prod"

# Network
vpc_name          = "myapp-prod-vpc"
subnet_name       = "myapp-prod-subnet"
subnet_cidr       = "10.2.0.0/24"
enable_psa        = true
psa_range_name    = "myapp-prod-psa"
psa_prefix_length = 16
enable_connector  = true
connector_cidr    = "10.10.0.0/28"

# Cloud SQL
instance_name       = "myapp-postgresql-prod"
db_name             = "appdb"
db_tier             = "db-custom-2-7680"
disk_size           = 100
availability_type   = "REGIONAL"
deletion_protection = true
backups_enabled     = true
pitr_enabled        = true
enable_read_replica = true

# Cloud Run
cloud_run_image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
min_instances   = 1
max_instances   = 10
cpu             = "2"
memory          = "2Gi"

# Load Balancer
domain               = "example.com"
ssl_certificate_name = "ssl-cert-prod"

# Security
rate_limit_requests = 1000
ban_duration_sec    = 900

# Service Account
service_account_name = "myapp-prod-sa"
