/* RESOURCES --------------------------------------*/

module "sync" {
  source = "github.com/status-im/infra-tf-google-cloud"

  /* node type */
  name  = "sync"
  group = "sync"

  /* scaling options */
  host_count = 1
  type       = "n1-standard-1"
  vol_size   = 30

  /* general */
  env    = var.env
  domain = var.hosts_domain

  /* firewall */
  open_tcp_ports = [
    "30303", /* Geth p2p */
  ]
}
