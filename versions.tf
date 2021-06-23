terraform {
  required_version = "~> 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.21.0"
    }
    ansible = {
      source  = "nbering/ansible"
      version = " = 1.0.4"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 2.0.0"
    }
    google = {
      source  = "hashicorp/google"
    }
  }
}
