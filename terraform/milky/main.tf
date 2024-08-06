variable "s3_bucket" {
    type = string
}
variable "s3_key" {
    type = string
}
variable "s3_region" {
    type = string
}
variable "s3_endpoint" {
    type = string
}
variable "s3_access_key" {
    type = string
}
variable "s3_secret_key" {
    type = string
}
variable "pm_api_url" {
    type = string
}
variable "pm_user" {
    type = string
}
variable "pm_password" {
    type = string
}

terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = ">= 3.0.0"
        }
    }
    backend "s3" {
        # Reference From https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm
        bucket = var.s3_bucket
        key    = var.s3_key
        region = var.s3_region
        endpoint = var.s3_endpoint
        access_key = var.s3_access_key
        secret_key = var.s3_secret_key
        skip_region_validation = true
        skip_credentials_validation = true
        skip_metadata_api_check = true
        skip_requesting_account_id = true
        skip_get_ec2_platforms = true
    }
}

provider "proxmox" {
    pm_api_url = var.pm_api_url
    pm_user = var.pm_user
    pm_password = var.pm_password
    pm_tls_insecure = true
}
