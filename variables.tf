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
# variable "secret_ssh_private_key_id" {
#   description = "Secret ID su SSH private key"
#   type        = string
# }

# variable "secret_db_password_id" {
#   description = "Secret ID su database password"
#   type        = string
# }

# Projekto kintamieji
variable "server_location" {
  description = "Hetzner server location"
  type        = string
  default     = "fsn1"
}

variable "secret_tailscale_api_key_id" {
  type = string
}

variable "secret_tailscale_tailnet_id" {
  type = string
}
variable "tailscale_tailnet" {
  type    = string
  # rasi Tailscale admin panelėje: Settings → General → Tailnet name
  # arba tiesiog pažiūrėk įrenginio FQDN panelėje
}