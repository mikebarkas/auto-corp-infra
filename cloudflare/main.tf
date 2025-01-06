terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_record" "api" {
  zone_id = var.zone_id
  name = var.name
  content = var.value
  type = var.type
  ttl = 3600
}
