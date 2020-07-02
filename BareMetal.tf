
resource "packet_project" "project" {
  name = format("opentack-%s", random_id.cloud.b64_url)
}

provider "packet" {
  auth_token = var.packet_auth_token
}

resource "packet_device" "controller" {
  hostname = "controller"
  tags     = ["openstack-${random_id.cloud.b64_url}"]

  operating_system = "ubuntu_18_04"
  plan             = var.packet_controller_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(var.cloud_ssh_key_path)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file(var.cloud_ssh_public_key_path)}\""
  facilities    = var.packet_facilities
  project_id    = packet_project.project.id
  billing_cycle = "hourly"
  #  ip_address {
  #    type = "public_ipv4"
  #    cidr = "29"
  #  }
}

resource "packet_device" "dashboard" {
  hostname = "dashboard"
  tags     = ["openstack-${random_id.cloud.hex} "]

  operating_system = "ubuntu_18_04"
  plan             = var.packet_dashboard_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(var.cloud_ssh_key_path)
  }
  user_data = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file(var.cloud_ssh_public_key_path)}\""

  facilities    = var.packet_facilities
  project_id    = packet_project.project.id
  billing_cycle = "hourly"
}

resource "packet_device" "compute-x86" {
  hostname = format("compute-x86-%02d", count.index)
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = var.openstack_compute-x86_count

  operating_system = "ubuntu_18_04"
  plan             = var.packet_compute-x86_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(var.cloud_ssh_key_path)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file(var.cloud_ssh_public_key_path)}\""
  facilities    = var.packet_facilities
  project_id    = packet_project.project.id
  billing_cycle = "hourly"
}

resource "packet_device" "compute-arm" {
  hostname = format("compute-arm-%02d", count.index)
  tags     = ["openstack-${random_id.cloud.hex} "]

  count = var.openstack_compute-arm_count

  operating_system = "ubuntu_18_04"
  plan             = var.packet_compute-arm_type
  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file(var.cloud_ssh_key_path)
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file(var.cloud_ssh_public_key_path)}\""
  facilities    = var.packet_facilities
  project_id    = packet_project.project.id
  billing_cycle = "hourly"
}

