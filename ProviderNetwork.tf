#
# Provider networking - IPv4 and IPv6
#

# use private IPv4 addresses to save precious Internet resources
data "packet_precreated_ip_block" "private_ipv4" {

  facility       = packet_device.controller.deployed_facility
  project_id     = var.packet_project_id
  address_family = 4
  public         = false

}

# /28 provides 16 IPs
resource "packet_ip_attachment" "controller_private_ipv4" {

  device_id      = packet_device.controller.id
  cidr_notation  = cidrsubnet(data.packet_precreated_ip_block.private_ipv4.cidr_notation,3,1)

}

# ipv6 is free so let's go crazy
data "packet_precreated_ip_block" "public_ipv6" {

  facility       = packet_device.controller.deployed_facility
  project_id     = var.packet_project_id
  address_family = 6
  public         = true

}

resource "packet_ip_attachment" "controller_public_ipv6" {

  device_id      = packet_device.controller.id
  cidr_notation  = cidrsubnet(data.packet_precreated_ip_block.public_ipv6.cidr_notation,8,1)

}
