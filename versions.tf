terraform {
  required_version = "~> 0.14.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.10.1"
    }
    google = {
      source  = "hashicorp/google"
      version = " = 3.42.0"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = " = 1.95.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = " = 2.5.1"
    }
    ansible = {
      source  = "nbering/ansible"
      version = " = 1.0.4"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 2.0.0"
    }
  }
}
