terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

variable "cloudflare_account_id" {
  type        = string
  description = "The Cloudflare account ID."
}

variable "cloudflare_api_token" {
  type        = string
  description = "The Cloudflare API token."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the project."
  default     = "open2roam.org"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_r2_bucket" "osm_data" {
  account_id = var.cloudflare_account_id
  name       = "osm-data"
  location   = "auto"
}

resource "cloudflare_zone" "primary" {
  account_id = var.cloudflare_account_id
  name       = var.domain_name
}

resource "cloudflare_record" "shell" {
  zone_id = cloudflare_zone.primary.id
  name    = "shell"
  value   = "pages.cloudflare.com" # Placeholder, will be a CNAME to the shell deployment
  type    = "CNAME"
  proxied = true
  ttl     = 1
}
