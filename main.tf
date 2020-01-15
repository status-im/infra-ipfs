/* PROVIDERS --------------------------------------*/

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  email      = var.cloudflare_email
  api_key    = var.cloudflare_token
  account_id = var.cloudflare_account
}

provider "google" {
  credentials = file("google-cloud.json")
  project     = "russia-servers"
  region      = "us-central1"
}

provider "alicloud" {
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
  region     = var.alicloud_region
}

/* BACKEND ----------------------------------------*/

terraform {
  backend "consul" {
    address = "https://consul.statusim.net:8400"
    lock    = true

    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/ipfs/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* WORKSPACES -----------------------------------*/

locals {
  ws         = merge(local.env["defaults"], local.env[terraform.workspace])
  dns_prefix = terraform.workspace == "prod" ? "" : "${terraform.workspace}-"
}

/* CF Zones ------------------------------------*/

/* CloudFlare Zone IDs required for records */
data "cloudflare_zones" "active" {
  filter { status = "active" }
}

/* For easier access to zone ID by domain name */
locals {
  zones = {
    for zone in data.cloudflare_zones.active.zones:
      zone.name => zone.id
  }
}

/* RESOURCES --------------------------------------*/

module "ipfs" {
  source = "github.com/status-im/infra-tf-google-cloud"

  /* node type */
  name  = "node"
  group = "ipfs"

  /* scaling options */
  host_count = local.ws["hosts_count"]
  type       = "n1-standard-2"
  vol_size   = 50

  /* general */
  env    = var.env
  domain = var.hosts_domain

  /* firewall */
  open_ports = [
    "80", /* HTTP */
    "443", /* HTTPS */
    "4001", /* IPFS Swarm */
    "2053", /* IPFS API Proxy */
    "9094-9096", /* IPFS Cluster */
  ]
}

resource "cloudflare_record" "ipfs" {
  zone_id = local.zones[var.public_domain]
  name    = "ipfs"
  type    = "A"
  proxied = true
  count   = length(module.ipfs.public_ips)
  value   = element(module.ipfs.public_ips, count.index)
}
