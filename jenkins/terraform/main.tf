
# Variables are assigned in x.tfvars
variable "linode_token" {
  type      = string
  sensitive = true
}
variable "root_passwd" {
  type      = string
  sensitive = true
}
variable "public_key" {
  type      = string
  sensitive = true
}

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.9.1"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "jenkins" {
  image           = "linode/fedora38"
  label           = "Jenkins"
  group           = "Jenkins"
  region          = "us-southeast"
  type            = "g6-nanode-1"
  authorized_keys = [var.public_key]
  root_pass       = var.root_passwd
}

resource "linode_firewall" "jenkins_server" {
  inbound_policy  = "DROP"
  label           = "Jenkins"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allow-http"
    ports    = "8080"
    protocol = "TCP"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }
  inbound {
    action   = "ACCEPT"
    label    = "allow-ssh"
    ports    = "22"
    protocol = "TCP"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  linodes = [linode_instance.jenkins.id]
}
