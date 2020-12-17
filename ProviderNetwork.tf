#
# Provider networking - IPv4 and IPv6
#

# use private IPv4 addresses to save precious Internet resources
data "metal_precreated_ip_block" "private_ipv4" {

  facility       = metal_device.controller.deployed_facility
  project_id     = metal_project.project.id
  address_family = 4
  public         = false

}

# /28 provides 16 IPs
resource "metal_ip_attachment" "controller_private_ipv4" {

  device_id     = metal_device.controller.id
  cidr_notation = cidrsubnet(data.metal_precreated_ip_block.private_ipv4.cidr_notation, 3, 1)

}

# ipv6 is free so let's go crazy
data "metal_precreated_ip_block" "public_ipv6" {

  facility       = metal_device.controller.deployed_facility
  project_id     = metal_project.project.id
  address_family = 6
  public         = true

}

resource "metal_ip_attachment" "controller_public_ipv6" {

  device_id     = metal_device.controller.id
  cidr_notation = cidrsubnet(data.metal_precreated_ip_block.public_ipv6.cidr_notation, 8, 1)

}

data "template_file" "network-interfaces-br-public" {

  template = file("${path.module}/templates/network-interfaces-br-public")

  vars = {
    # Use the first IP in each subnet for gateway
    provider_ipv4_cidr = join("/", [cidrhost(metal_ip_attachment.controller_private_ipv4.cidr_notation, 1), metal_ip_attachment.controller_private_ipv4.cidr])
    provider_ipv6_cidr = join("/", [cidrhost(metal_ip_attachment.controller_public_ipv6.cidr_notation, 1), metal_ip_attachment.controller_public_ipv6.cidr])
  }
}

resource "null_resource" "enable-br-public" {
  depends_on = [null_resource.controller-keystone]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.network-interfaces-br-public.rendered
    destination = "network-interfaces-br-public"
  }

  # controller-keystone is required for the bridge-utils package to ifup br-public
  provisioner "remote-exec" {
    inline = [
      "cat network-interfaces-br-public >> /etc/network/interfaces",
      "ifup br-public",
    ]
  }

}

data "template_file" "provider-networks" {

  template = file("${path.module}/templates/ProviderNetworks.sh")

  vars = {
    ADMIN_PASS         = random_password.os_admin_password.result
    provider_ipv4_cidr = metal_ip_attachment.controller_private_ipv4.cidr_notation
    provider_ipv6_cidr = metal_ip_attachment.controller_public_ipv6.cidr_notation
  }
}

resource "null_resource" "controller-provider-networks" {
  depends_on = [null_resource.controller-neutron,
  null_resource.openstack-sample-workload-common]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.provider-networks.rendered
    destination = "ProviderNetworks.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ProviderNetworks.sh > ProviderNetworks.out || cat ProviderNetworks.out"
    ]
  }
}
