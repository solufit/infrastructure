variable "s3_bucket" {
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
variable "pm_api_token_id" {
  type = string
}
variable "pm_api_token_secret" {
  type = string
}

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
  backend "s3" {
    # Reference From https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm
    bucket     = ""
    key        = "milky-terraform.tfstate"
    region     = ""
    endpoint   = ""
    access_key = ""
    secret_key = ""

    # AWS認証をスキップ
    force_path_style            = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_get_ec2_platforms      = true
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret

}
