/* Token for interacting with Cloudflare API. */
data "pass_password" "cloudflare_token" {
  path = "cloud/Cloudflare/token"
}

/* Email address of Cloudflare account. */
data "pass_password" "cloudflare_email" {
  path = "cloud/Cloudflare/email"
}

/* ID of CloudFlare Account. */
data "pass_password" "cloudflare_account" {
  path = "cloud/Cloudflare/account"
}

/* Google Cloud API auth JSON */
data "pass_password" "google_cloud_cred_json" {
  path = "cloud/GoogleCloud/json"
}
