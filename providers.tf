provider "cloudflare" {
  email      = data.pass_password.cloudflare_email.password
  api_key    = data.pass_password.cloudflare_token.password
  account_id = data.pass_password.cloudflare_account.password
}

provider "google" {
  credentials = data.pass_password.google_cloud_cred_json.full
  project     = "russia-servers"
  region      = "us-central1"
}

# Uses PASSWORD_STORE_DIR environment variable
provider "pass" {}
