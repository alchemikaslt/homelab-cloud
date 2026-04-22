
output "tailscale_ip" {
  value = data.tailscale_device.server.addresses[0]
}
