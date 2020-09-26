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
