/* CONFIG ----------------------------------------*/

variable ssh_keys {
  description = "Names of ssh public keys to add to created hosts"
  type        = "list"
  # ssh key IDs acquired using doctl
  default     = ["16822693", "18813432", "18813461", "19525749", "20671731", "20686611"]
}

variable env {
  description = "Environment for these hosts, affects DNS entries."
  default     = "ipfs"
}

variable public_domain {
  description = "Public DNS Domain to update"
  default     = "status.im"
}

variable hosts_domain {
  description = "Hosts DNS Domain to update"
  default     = "statusim.net"
}

variable ssh_user {
  description = "User used to log in to instance"
  default     = "root"
}


/* PROVIDERS ------------------------------------*/

variable cloudflare_token {
  description = "Token for interacting with Cloudflare API."
}

variable digitalocean_token {
  description = "Token for interacting with DigitalOcean API."
}

variable cloudflare_email {
  description = "Email address of Cloudflare account."
}

variable cloudflare_org_id {
  description = "ID of the CloudFlare organization."
}

variable alicloud_access_key {
  description = "Alibaba Cloud API access key."
}

variable alicloud_secret_key {
  description = "Alibaba Cloud API secret key."
}

variable alicloud_region {
  description = "Alibaba Cloud hosting region."
  default     = "cn-hongkong"
}
