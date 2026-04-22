output "server_ip" {
  description = "Viešas serverio IP adresas"
  value       = hcloud_server.web.ipv4_address
}

# Serverio ID
output "server_id" {
  description = "Hetzner serverio ID"
  value       = hcloud_server.web.id
}

# Serverio pavadinimas
output "server_name" {
  description = "Serverio pavadinimas"
  value       = hcloud_server.web.name
}

# Jautrus duomuo (slaptažodis ir pan.)
output "server_status" {
  description = "Serverio būsena"
  value       = hcloud_server.web.status
  sensitive   = true  # nerodomas terminale, bet saugomas state'e
}