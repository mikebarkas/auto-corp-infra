
variable "api_token" {
  description = "The API token for the account"
  type = string
}

variable "zone_id" {
  description = "The zone id"
  type = string
}

variable "name" {
  description = "The subdomain www"
  type = string
}

variable "value" {
  description = "The IP address value"
  type = string
}

variable "type" {
  description = "The record type: A, AAAA, CNAME"
  type = string
}
