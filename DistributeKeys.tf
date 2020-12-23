#
# copy the keys over to the controller to allow SSH access to the other nodes
#

resource "null_resource" "controller-distribute-keys" {
  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = local_file.cluster_private_key_pem.filename
    destination = "openstack_rsa"
  }

  provisioner "file" {
    source      = local_file.cluster_public_key.filename
    destination = "openstack_rsa.pub"
  }
}

# keep a set on the dashboard as a backup in case the controller is down

resource "null_resource" "dashboard-distribute-keys" {
  connection {
    host        = metal_device.dashboard.access_public_ipv4
    private_key = local_file.cluster_private_key_pem.content
  }

  provisioner "file" {
    source      = local_file.cluster_private_key_pem.filename
    destination = "openstack_rsa"
  }

  provisioner "file" {
    source      = local_file.cluster_public_key.filename
    destination = "openstack_rsa.pub"
  }
}

