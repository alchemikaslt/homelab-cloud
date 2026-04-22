# Kintamųjų deklaracijos
variable "BW_ACCESS_TOKEN" {
  description = "Bitwarden Secrets Manager access token"
  type        = string
  sensitive   = true
  default     = null  # Naudos BW_ACCESS_TOKEN aplinkos kintamąjį
}
variable "BW_ORGANIZATION_ID" {
  description = "Bitwarden Secrets Manager organization id"
  type        = string
  sensitive   = true
  default     = null
}

# Secret ID's iš Bitwarden Secrets Manager
variable "secret_hcloud_token_id" {
  description = "Secret ID su Hetzner Cloud API token"
  type        = string
}

variable "secret_ssh_public_key_id" {
  description = "Secret ID su SSH public key"
  type        = string
}
variable "secret_ssh_public_key_egidijos_id" {
  description = "Secret ID su SSH public key Egidijos"
  type        = string
}
 variable "secret_cloudflare_api_token_id" {
   description = "Cloudflare API token"
   type        = string
   sensitive   = true
 }

variable "secret_tailscale_api_key_id" {
  type = string
}

variable "secret_tailscale_tailnet_id" {
  type = string
}
variable "tailscale_tailnet" {
  type    = string
}