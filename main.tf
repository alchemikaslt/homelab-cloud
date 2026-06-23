terraform {
    required_version = ">= 1.0"
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
            version = "~> 1.66"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "5.21.0"
        }
        bitwarden-secrets = {
            source = "bitwarden/bitwarden-secrets"
            version = "1.0.0"
        }
        tailscale = {
          source  = "tailscale/tailscale"
          version = "~> 0.29.2"
        }
        time = {
          source  = "hashicorp/time"
          version = "0.14"
        }
    }
    backend "s3" {
    bucket = "tf-backend"
    key    = "homelab-cloud/terraform.tfstate"
    region = "auto"               # R2 reikalauja "auto", ne realų regioną

    # Endpoint ir raktai perduodami per backend-secrets.hcl, kad nebūtų viešai matomi
    # endpoints = {
    #   s3 = "https://<ACCOUNT_ID>.r2.cloudflarestorage.com"
    # }

    # AWS-specifiniai patikrinimai išjungti, nes R2 nėra AWS
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true

    use_path_style = true

    # Native S3-style state locking (Terraform >= 1.10)
    # R2 dabar palaiko conditional writes (If-None-Match),
    # todėl šis mechanizmas veikia be DynamoDB analogo.
    use_lockfile = true
  }
}

# Bitwarden Secrets Manager provider
provider "bitwarden-secrets" {
    api_url      = "https://api.bitwarden.com"
    identity_url = "https://identity.bitwarden.com"
    access_token = var.BW_ACCESS_TOKEN
    organization_id = var.BW_ORGANIZATION_ID
}
provider "cloudflare" {
    api_token = data.bitwarden-secrets_secret.cloudflare_api_token.value
}
# Hetzner Cloud provider su secret iš Bitwarden
provider "hcloud" {
  token = local.hcloud_token
}
# provider "tailscale" {
#   api_key = data.bitwarden-secrets_secret.tailscale_api_key.value
#   tailnet = data.bitwarden-secrets_secret.tailscale_tailnet.value
# }
provider "tailscale" {
  api_key = module.bitwarden_secrets.tailscale_api_key
  tailnet = module.bitwarden_secrets.tailscale_tailnet
}

provider "time" {
  # Configuration options
}

module "server" {
  source = "./modules/server"
  hcloud_token            = local.hcloud_token
  my_ssh_public_key       = module.bitwarden_secrets.ssh_public_key
  # egidijos_ssh_public_key = data.bitwarden-secrets_secret.ssh_public_key_egidijos.value
  # ansible_ssh_public_key  = data.bitwarden-secrets_secret.ssh_public_key_egidijos.value
  egidijos_ssh_public_key = module.bitwarden_secrets.ssh_public_key_egidijos
  ansible_ssh_public_key  = module.bitwarden_secrets.ssh_public_key
  tailscale_auth_key      = tailscale_tailnet_key.server_key.key
  tailscale_tailnet       = var.tailscale_tailnet
}
module "bitwarden_secrets" {
  source = "./modules/bitwarden-secrets"
  # BW_ACCESS_TOKEN = var.BW_ACCESS_TOKEN
  # BW_ORGANIZATION_ID = var.BW_ORGANIZATION_ID
  secret_hcloud_token_id = var.secret_hcloud_token_id
  secret_ssh_public_key_id = var.secret_ssh_public_key_id
  secret_ssh_public_key_egidijos_id = var.secret_ssh_public_key_egidijos_id
  secret_cloudflare_api_token_id = var.secret_cloudflare_api_token_id
  secret_tailscale_api_key_id = var.secret_tailscale_api_key_id
  secret_tailscale_tailnet_id = var.secret_tailscale_tailnet_id
}