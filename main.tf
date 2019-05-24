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
  source      = "github.com/status-im/infra-tf-multi-provider"
  /* node type */
  name        = "node"
  group       = "ipfs"
  /* scaling options */
  count       = "${local.ws["hosts_count"]}"
  do_size     = "s-1vcpu-2gb"
  gc_size     = "n1-standard-2"
  ac_size     = "ecs.sn1ne.large"
  gc_vol_size = 50
  /* general */
  env         = "${var.env}"
  domain      = "${var.domain}"
  /* firewall */
  open_ports  = [
    "443-443",   /* https */
    "4001-4001", /* IPFS Swarm */
    "9094-9096", /* IPFS Cluster */
  ]
}

resource "cloudflare_load_balancer_monitor" "main" {
  description    = "Root health check"
  expected_codes = "2xx"
  expected_body  = ""
  method         = "GET"
  type           = "https"
  path           = "/"
  interval       = 60
  retries        = 5
  timeout        = 7
  /* disables SSl cert check, this way we can use origin */
  allow_insecure = true
}

/* WARNING: Statically done until Terraform 0.12 arrives */
resource "cloudflare_load_balancer_pool" "main" {
  name               = "main.${terraform.workspace}.${var.env}"
  monitor            = "${cloudflare_load_balancer_monitor.main.id}"
  notification_email = "jakub@status.im"
  minimum_origins    = 1
  origins {
    name    = "${element(keys(module.ipfs.hosts["do-eu-amsterdam3"]), 0)}"
    address = "${element(values(module.ipfs.hosts["do-eu-amsterdam3"]), 0)}"
    enabled = true
  }
  origins {
    name    = "${element(keys(module.ipfs.hosts["gc-us-central1-a"]), 0)}"
    address = "${element(values(module.ipfs.hosts["gc-us-central1-a"]), 0)}"
    enabled = true
  }
  origins {
    name    = "${element(keys(module.ipfs.hosts["ac-cn-hongkong-c"]), 0)}"
    address = "${element(values(module.ipfs.hosts["ac-cn-hongkong-c"]), 0)}"
    enabled = true
  }
}

// This might work, not sure yet
resource "cloudflare_load_balancer" "main" {
  zone             = "status.im"
  name             = "${local.dns_prefix}${var.env}.status.im"
  description      = "Load balancing of IPFS fleet."
  proxied          = true

  fallback_pool_id = "${cloudflare_load_balancer_pool.main.id}"
  default_pool_ids = ["${cloudflare_load_balancer_pool.main.id}"]
}
