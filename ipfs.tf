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
  open_tcp_ports = [
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
