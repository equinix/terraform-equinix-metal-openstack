resource "equinix_metal_project" "new_project" {
  count           = var.equinix_metal_create_project ? 1 : 0
  name            = (var.equinix_metal_project_name != "") ? var.equinix_metal_project_name : format("openstack-%s", random_id.cloud.b64_url)
  organization_id = var.equinix_metal_organization_id
}

provider "equinix" {
  auth_token = var.equinix_metal_auth_token
}

locals {
  ssh_key_name     = "metal-key"
  metal_project_id = var.equinix_metal_create_project ? equinix_metal_project.new_project[0].id : var.equinix_metal_project_id
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "equinix_metal_ssh_key" "ssh_pub_key" {
  name       = random_id.cloud.b64_url
  public_key = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
}

resource "local_file" "cluster_private_key_pem" {
  content         = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  filename        = pathexpand(format("%s", local.ssh_key_name))
  file_permission = "0600"
}

resource "local_file" "cluster_public_key" {
  content         = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  filename        = pathexpand(format("%s.pub", local.ssh_key_name))
  file_permission = "0600"
}

resource "equinix_metal_device" "controller" {
  hostname = "controller"
  tags     = ["openstack-${random_id.cloud.b64_url}"]

  operating_system = "ubuntu_18_04"
  plan             = var.equinix_metal_controller_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = local_file.cluster_private_key_pem.content
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${local_file.cluster_public_key.content}\""
  metro         = var.metal_metro
  project_id    = local.metal_project_id
  billing_cycle = "hourly"
  #  ip_address {
  #    type = "public_ipv4"
  #    cidr = "29"
  #  }
}

resource "equinix_metal_device" "dashboard" {
  hostname = "dashboard"
  tags     = ["openstack-${random_id.cloud.hex} "]

  operating_system = "ubuntu_18_04"
  plan             = var.equinix_metal_dashboard_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(local_file.cluster_private_key_pem)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${local_file.cluster_public_key.content}\""
  metro         = var.metal_metro
  project_id    = local.metal_project_id
  billing_cycle = "hourly"
}

resource "equinix_metal_device" "compute-x86" {
  hostname = format("compute-x86-%02d", count.index)
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = var.openstack_compute-x86_count

  operating_system = "ubuntu_18_04"
  plan             = var.equinix_metal_compute-x86_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(local_file.cluster_private_key_pem)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${local_file.cluster_public_key.content}\""
  metro         = var.metal_metro
  project_id    = local.metal_project_id
  billing_cycle = "hourly"
}

resource "equinix_metal_device" "compute-arm" {
  hostname = format("compute-arm-%02d", count.index)
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = var.openstack_compute-arm_count

  operating_system = "ubuntu_18_04"
  plan             = var.equinix_metal_compute-arm_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(local_file.cluster_private_key_pem)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${local_file.cluster_public_key.content}\""
  metro         = var.metal_metro
  project_id    = local.metal_project_id
  billing_cycle = "hourly"
}

