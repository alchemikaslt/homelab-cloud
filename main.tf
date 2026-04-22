terraform {
    required_version = ">= 1.0"
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
            version = "~> 1.60"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "5.16.0"
        }
        bitwarden-secrets = {
            source = "bitwarden/bitwarden-secrets"
            version = "0.5.4-pre"
        }
        tailscale = {
          source  = "tailscale/tailscale"
          version = "~> 0.28"
        }
        time = {
          source  = "hashicorp/time"
          version = "0.13.1"
        }
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
provider "tailscale" {
  api_key = data.bitwarden-secrets_secret.tailscale_api_key.value
  tailnet = data.bitwarden-secrets_secret.tailscale_tailnet.value
}

provider "time" {
  # Configuration options
}
# Pavyzdinis serveris
resource "hcloud_server" "web" {
  name        = "homelab-server"
  server_type = "cx23"
  image       = "debian-13"
  location    = var.server_location
  
  ssh_keys = [hcloud_ssh_key.my.id, hcloud_ssh_key.egidijos.id]
  
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = templatefile("cloud-init.yaml", {
    tailscale_auth_key = tailscale_tailnet_key.server_key.key
  })

  labels = {
    environment = "homelab"
    managed_by  = "terraform"
  }
}

# SSH raktas serverio priėjimui
resource "hcloud_ssh_key" "my" {
  name       = "homelab-ssh-key-my"
  public_key = data.bitwarden-secrets_secret.ssh_public_key.value
}
resource "hcloud_ssh_key" "egidijos" {
  name       = "homelab-ssh-key-egidijos"
  public_key = data.bitwarden-secrets_secret.ssh_public_key_egidijos.value
}