# Projekto kintamieji
variable "server_location" {
  description = "Hetzner server location"
  type        = string
  default     = "fsn1"
}

variable "hcloud_token" {
  type = string
  sensitive = true
}

variable "my_ssh_public_key" {
  type = string
  sensitive = true
}
variable "egidijos_ssh_public_key" {
  type = string
  sensitive = true
}
variable "ansible_ssh_public_key" {
  type = string
  sensitive = true
}
variable "tailscale_auth_key" {
  type = string
  sensitive = true
}
variable "tailscale_tailnet" {
  type = string
  sensitive = false
}
variable "allowed_ssh_ips" {
  description = "Sąrašas IP adresų (CIDR), kuriems leidžiama laikinai prisijungti per emergency SSH (port 22)"
  type        = list(string)
  default     = []
}


locals {
    hostname        = "homelab-server"
    //ansible_ssh_public_key  = data.bitwarden-secrets_secret.ssh_public_key.value
}