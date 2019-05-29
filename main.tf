/* PROVIDERS --------------------------------------*/

provider "digitalocean" {
  token   = "${var.digitalocean_token}"
  version = "<= 0.1.3"
}
provider "cloudflare" {
  email  = "${var.cloudflare_email}"
  token  = "${var.cloudflare_token}"
  org_id = "${var.cloudflare_org_id}"
}
provider "google" {
  credentials = "${file("google-cloud.json")}"
  project     = "russia-servers"
  region      = "us-central1"
}
provider "alicloud" {
  access_key = "${var.alicloud_access_key}"
  secret_key = "${var.alicloud_secret_key}"
  region     = "${var.alicloud_region}"
}

/* BACKEND ----------------------------------------*/

terraform {
  backend "consul" {
    address   = "https://consul.statusim.net:8400"
    lock      = true
    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/ipfs/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* WORKSPACES -----------------------------------*/

locals {
  ws         = "${merge(local.env["defaults"], local.env[terraform.workspace])}"
  dns_prefix = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
}

/* RESOURCES --------------------------------------*/

module "ipfs" {
  source      = "github.com/status-im/infra-tf-google-cloud"
  /* node type */
  name        = "node"
  group       = "ipfs"
  /* scaling options */
  count       = "${local.ws["hosts_count"]}"
  type        = "n1-standard-1"
  vol_size    = 50
  /* general */
  env         = "${var.env}"
  domain      = "${var.hosts_domain}"
  /* firewall */
  open_ports  = [
    "80-80",     /* HTTP */
    "443-443",   /* HTTPS */
    "4001-4001", /* IPFS Swarm */
    "9094-9096", /* IPFS Cluster */
    "2053-2053", /* IPFS API Proxy */
  ]
}

resource "cloudflare_record" "ipfs" {
  domain  = "${var.public_domain}"
  name    = "${terraform.workspace}-${var.env}"
  type    = "A"
  proxied = true
  count   = "${length(module.ipfs.public_ips)}"
  value   = "${element(module.ipfs.public_ips, count.index)}"
}
