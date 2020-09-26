terraform {
  required_version = "~> 0.13.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.10.1"
    }
    google = {
      source  = "hashicorp/google"
      version = " = 3.40.0"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = " = 1.95.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = " = 1.22.2"
    }
    ansible = {
      source  = "nbering/ansible"
      version = " = 1.0.4"
    }
  }
}
