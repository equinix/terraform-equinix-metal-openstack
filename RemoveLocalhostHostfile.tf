#
# Remove named 127.0.0.1 entry
#

resource "null_resource" "controller-removelocalhost-hostfile" {
  connection {
    host        = equinix_metal_device.controller.access_public_ipv4
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = "${path.module}/assets/hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts",
    ]
  }
}

resource "null_resource" "dashboard-removelocalhost-hostfile" {
  connection {
    host        = equinix_metal_device.dashboard.access_public_ipv4
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts",
    ]
  }
}

resource "null_resource" "compute-x86-removelocalhost-hostfile" {
  count = var.openstack_compute-x86_count

  connection {
    host        = element(equinix_metal_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts",
    ]
  }
}

resource "null_resource" "compute-arm-removelocalhost-hostfile" {
  count = var.openstack_compute-arm_count

  connection {
    host        = element(equinix_metal_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/127.0.0.1.*/127.0.0.1 localhost/' /etc/hosts",
    ]
  }
}

