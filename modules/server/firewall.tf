resource "hcloud_firewall" "closed_perimeter" {
  name = "homelab-closed-perimeter"

  dynamic "rule" {
    for_each = length(var.allowed_ssh_ips) > 0 ? [1] : []
    content {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = var.allowed_ssh_ips
    }
  }
  
  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "1-65535"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "udp"
    port            = "1-65535"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall_attachment" "closed_perimeter_attachment" {
  firewall_id = hcloud_firewall.closed_perimeter.id
  server_ids  = [hcloud_server.web.id]
}