MANUAL STEPS

A. BEFORE RUNNING TERRAFORM

1. Create projects for all necessary environment (Dev, Staging, Prod)
2. Create central project to store Terraform state/GCS backend
3. Create a GCS bucket on the central project

    gcloud services enable storage.googleapis.com
    gcloud storage buckets create gs://central-project-terraform-states --project=project-prod --location=asia-southeast2
    gcloud storage buckets update gs://central-project-terraform-states --versioning

4. On each project, create self-managed certificate in GCP's Certificate Manager
   
   Example for Prod:
    gcloud services enable certificatemanager.googleapis.com
    gcloud certificate-manager certificates create ssl-cert-prod\
        --certificate-file="example-cert.pem" \
        --private-key-file="example-private-key.pem" \
        --location="global"

B. AFTER RUNNING TERRAFORM
Using Cloud SQL Studio on Google Cloud Console, log in using postgres user and execute the following script to create table, create one row of data, and grant select access to the table:

Example for Prod:

    CREATE EXTENSION IF NOT EXISTS pgcrypto;

    CREATE TABLE IF NOT EXISTS "myapp" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    address VARCHAR(255)
    );

    INSERT INTO "myapp" (name, address)
    VALUES ('Indrayana', 'Jakarta');

    GRANT SELECT
    ON "myapp"
    TO "myapp-prod-sa@project-prod.iam";



