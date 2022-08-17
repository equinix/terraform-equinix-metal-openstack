#
# Setup /etc/hosts across all nodes
#

resource "null_resource" "blank-hostfile" {
  provisioner "local-exec" {
    command = "rm -f ${path.module}/assets/hostfile"
  }
}

#
# gather the IP address from all the nodes
#
resource "null_resource" "controller-generate-hostfile" {
  depends_on = [null_resource.blank-hostfile]

  provisioner "local-exec" {
    command = "echo ${equinix_metal_device.controller.access_private_ipv4} ${equinix_metal_device.controller.hostname} >> ${path.module}/assets/hostfile"
  }
}

resource "null_resource" "dashboard-generate-hostfile" {
  depends_on = [null_resource.blank-hostfile]

  provisioner "local-exec" {
    command = "echo ${equinix_metal_device.dashboard.access_private_ipv4} ${equinix_metal_device.dashboard.hostname} >> ${path.module}/assets/hostfile"
  }
}

resource "null_resource" "compute-x86-generate-hostfile" {
  depends_on = [null_resource.blank-hostfile]

  count = var.openstack_compute-x86_count

  provisioner "local-exec" {
    command = "echo ${element(equinix_metal_device.compute-x86.*.access_private_ipv4, count.index)} ${element(equinix_metal_device.compute-x86.*.hostname, count.index)} >> ${path.module}/assets/hostfile"
  }
}

resource "null_resource" "compute-arm-generate-hostfile" {
  depends_on = [null_resource.blank-hostfile]

  count = var.openstack_compute-arm_count

  provisioner "local-exec" {
    command = "echo ${element(equinix_metal_device.compute-arm.*.access_private_ipv4, count.index)} ${element(equinix_metal_device.compute-arm.*.hostname, count.index)} >> ${path.module}/assets/hostfile"
  }
}

#
# checkpoint
#
resource "null_resource" "hostfile-generated" {
  depends_on = [
    null_resource.controller-generate-hostfile,
    null_resource.dashboard-generate-hostfile,
    null_resource.compute-x86-generate-hostfile,
    null_resource.compute-arm-generate-hostfile,
  ]
}

#
# write out the hosts onto the nodes
#
resource "null_resource" "controller-write-hostfile" {
  depends_on = [null_resource.hostfile-generated]

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
      "cat hostfile >> /etc/hosts",
    ]
  }
}

resource "null_resource" "dashboard-write-hostfile" {
  depends_on = [null_resource.hostfile-generated]

  connection {
    host        = equinix_metal_device.dashboard.access_public_ipv4
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = "${path.module}/assets/hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts",
    ]
  }
}

resource "null_resource" "compute-x86-write-hostfile" {
  depends_on = [null_resource.hostfile-generated]

  count = var.openstack_compute-x86_count

  connection {
    host        = element(equinix_metal_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = "${path.module}/assets/hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts",
    ]
  }
}

resource "null_resource" "compute-arm-write-hostfile" {
  depends_on = [null_resource.hostfile-generated]

  count = var.openstack_compute-arm_count

  connection {
    host        = element(equinix_metal_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = "${path.module}/assets/hostfile"
    destination = "hostfile"
  }

  provisioner "remote-exec" {
    inline = [
      "cat hostfile >> /etc/hosts",
    ]
  }
}

# checkpoint
resource "null_resource" "hostfile-distributed" {
  depends_on = [
    null_resource.controller-write-hostfile,
    null_resource.dashboard-write-hostfile,
    null_resource.compute-x86-write-hostfile,
    null_resource.compute-arm-write-hostfile,
    null_resource.controller-removelocalhost-hostfile,
    null_resource.dashboard-removelocalhost-hostfile,
    null_resource.compute-x86-removelocalhost-hostfile,
    null_resource.compute-arm-removelocalhost-hostfile,
  ]

  provisioner "local-exec" {
    command = "echo all systems have updated hostfile"
  }
}

