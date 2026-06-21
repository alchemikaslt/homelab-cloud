output "hcloud_token" {
  description = "Hetzner Cloud API token"
  value       = data.bitwarden-secrets_secret.hcloud_token.value
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key (pagrindinis)"
  value       = data.bitwarden-secrets_secret.ssh_public_key.value
  sensitive   = true
}

output "ssh_public_key_egidijos" {
  description = "SSH public key (egidijos)"
  value       = data.bitwarden-secrets_secret.ssh_public_key_egidijos.value
  sensitive   = true
}

output "cloudflare_api_token" {
  description = "Cloudflare API token"
  value       = data.bitwarden-secrets_secret.cloudflare_api_token.value
  sensitive   = true
}

output "tailscale_api_key" {
  description = "Tailscale API key"
  value       = data.bitwarden-secrets_secret.tailscale_api_key.value
  sensitive   = true
}

output "tailscale_tailnet" {
  description = "Tailscale tailnet pavadinimas"
  value       = data.bitwarden-secrets_secret.tailscale_tailnet.value
  sensitive   = true
}