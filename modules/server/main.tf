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
    tailscale_auth_key = var.tailscale_auth_key
    tailscale_hostname = local.hostname
    tailscale_tailnet = var.tailscale_tailnet
    ansible_ssh_public_key = var.ansible_ssh_public_key
  })

  labels = {
    environment = "homelab"
    managed_by  = "terraform"
  }
}

# SSH raktas serverio priėjimui
resource "hcloud_ssh_key" "my" {
  name       = "homelab-ssh-key-my"
  public_key = var.my_ssh_public_key
}
resource "hcloud_ssh_key" "egidijos" {
  name       = "homelab-ssh-key-egidijos"
  public_key = var.egidijos_ssh_public_key
}