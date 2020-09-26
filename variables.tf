variable "ssh_keys" {
  description = "Names of ssh public keys to add to created hosts"
  type        = list(string)
  # ssh key IDs acquired using doctl
  default = ["16822693", "18813432", "18813461", "19525749", "20671731", "20686611"]
}

variable "env" {
  description = "Environment for these hosts, affects DNS entries."
  type        = string
  default     = "ipfs"
}

variable "public_domain" {
  description = "Public DNS Domain to update"
  type        = string
  default     = "status.im"
}

variable "hosts_domain" {
  description = "Hosts DNS Domain to update"
  type        = string
  default     = "statusim.net"
}

variable "ssh_user" {
  description = "User used to log in to instance"
  type        = string
  default     = "root"
}
