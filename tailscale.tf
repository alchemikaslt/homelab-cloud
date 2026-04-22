# tailscale.tf — automatiškai sukuria auth key
resource "tailscale_tailnet_key" "server_key" {
  reusable      = false   # vienkartinis raktas geriau saugumui
  ephemeral     = false   # serveris lieka tailnet po restart
  preauthorized = true    # nereikia rankinio patvirtinimo
  expiry        = 3600    # 1 val. — užtenka provisioningui

  tags = ["tag:terraform"]   # opcionaliai, jei naudoji ACL tags
}

resource "time_sleep" "wait_for_tailscale" {
  depends_on      = [module.server]
  create_duration = "60s"  # duodam laiko cloud-init užbaigti
}

data "tailscale_device" "server" {
  # name     = "${hcloud_server.web.name}.${var.tailscale_tailnet}.ts.net"  # turi sutapti su hostname
  name     = "${module.server.server_name}.${var.tailscale_tailnet}.ts.net" 
  wait_for = "120s"        # lauks kol device pasirodys API

  depends_on = [time_sleep.wait_for_tailscale]
}