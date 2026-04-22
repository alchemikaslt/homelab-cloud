# Gauti Hetzner Cloud API token
data "bitwarden-secrets_secret" "hcloud_token" {
  id = var.secret_hcloud_token_id
}

# Gauti SSH public key
data "bitwarden-secrets_secret" "ssh_public_key" {
  id = var.secret_ssh_public_key_id
}

data "bitwarden-secrets_secret" "cloudflare_api_token" {
    id = var.secret_cloudflare_api_token_id
}

data "bitwarden-secrets_secret" "ssh_public_key_egidijos" {
    id = var.secret_ssh_public_key_egidijos_id
}

data "bitwarden-secrets_secret" "tailscale_api_key" {
    id = var.secret_tailscale_api_key_id
}

data "bitwarden-secrets_secret" "tailscale_tailnet" {
    id = var.secret_tailscale_tailnet_id
}

# # Gauti SSH private key (jei reikia)
# data "bws_secret" "ssh_private_key" {
#   id = var.secret_ssh_private_key_id
# }

# # Gauti database credentials
# data "bws_secret" "db_password" {
#   id = var.secret_db_password_id
# }

# Lokalūs kintamieji patogesniam naudojimui
locals {
  hcloud_token    = data.bitwarden-secrets_secret.hcloud_token.value
  ssh_public_key  = data.bitwarden-secrets_secret.ssh_public_key.value
  # ssh_private_key = data.bitwarden-secret_secrets.ssh_private_key.value
  # db_password     = data.bitwarden-secret_secrets.db_password.value
}