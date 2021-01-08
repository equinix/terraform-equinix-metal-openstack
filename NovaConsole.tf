#
# serial console required for ARM systems
#

resource "null_resource" "novaconsole" {
  depends_on = [null_resource.controller-nova]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(local_file.cluster_private_key_pem.content)
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install -y git",
      "git clone http://github.com/larsks/novaconsole.git",
      "cd novaconsole",
      "python setup.py install",
    ]
  }
}

