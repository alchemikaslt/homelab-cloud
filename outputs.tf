
output "tailscale_ip" {
  value = data.tailscale_device.server.addresses[0]
}
output "server_ip" {
  value = module.server.server_ip
}
output "server_ipv6" {
  value = module.server.server_ipv6
}
output "server_ipv4" {
  value = module.server.server_ipv4
}