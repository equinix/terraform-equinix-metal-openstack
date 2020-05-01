resource "null_resource" "controller-keystone" {
  depends_on = [null_resource.hostfile-distributed]

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "file" {
    source      = "ControllerKeystone.sh"
    destination = "ControllerKeystone.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
      "bash ControllerKeystone.sh > ControllerKeystone.out",
    ]
  }
}

# we setup glance early so the images can start download while the rest of the cloud builds
resource "null_resource" "controller-glance" {
  depends_on = [null_resource.controller-keystone]

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "ControllerGlance.sh"
    destination = "ControllerGlance.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerGlance.sh > ControllerGlance.out",
    ]
  }
}

resource "null_resource" "controller-nova" {
  depends_on = [null_resource.controller-glance]

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "ControllerNova.sh"
    destination = "ControllerNova.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerNova.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ControllerNova.out",
    ]
  }
}

resource "null_resource" "controller-neutron" {
  depends_on = [null_resource.controller-nova,
                null_resource.enable-br-public]

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "ControllerNeutron.sh"
    destination = "ControllerNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerNeutron.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ControllerNeutron.out",
    ]
  }
}

resource "null_resource" "dashboard-install" {
  depends_on = [null_resource.hostfile-distributed]

  connection {
    host        = packet_device.dashboard.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y install openstack-dashboard > Dashboard.out",
    ]
  }
}

resource "null_resource" "dashboard-config" {
  depends_on = [null_resource.dashboard-install]

  connection {
    host        = packet_device.dashboard.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "local_settings.py"
    destination = "/etc/openstack-dashboard/local_settings.py"
  }

  provisioner "file" {
    source      = "Packet-splash.svg"
    destination = "/var/lib/openstack-dashboard/static/dashboard/img/logo-splash.svg"
  }

  provisioner "file" {
    source      = "Packet-logo.svg"
    destination = "/var/lib/openstack-dashboard/static/dashboard/img/logo.svg"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl reload apache2.service",
    ]
  }
}

resource "null_resource" "compute-x86-common" {
  depends_on = [null_resource.hostfile-distributed]

  count = var.openstack_compute-x86_count

  connection {
    host        = element(packet_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }
}

resource "null_resource" "compute-x86-openstack" {
  depends_on = [null_resource.compute-x86-common]

  count = var.openstack_compute-x86_count

  connection {
    host        = element(packet_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "ComputeNova.sh"
    destination = "ComputeNova.sh"
  }

  provisioner "file" {
    source      = "ComputeNeutron.sh"
    destination = "ComputeNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ComputeNova.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ComputeNeutron.out",
    ]
  }
}

resource "null_resource" "compute-arm-common" {
  depends_on = [null_resource.hostfile-distributed]

  count = var.openstack_compute-arm_count

  connection {
    host        = element(packet_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "CommonServerSetup.sh"
    destination = "CommonServerSetup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }
}

resource "null_resource" "compute-arm-openstack" {
  depends_on = [null_resource.compute-arm-common]

  count = var.openstack_compute-arm_count

  connection {
    host        = element(packet_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "ComputeNova.sh"
    destination = "ComputeNova.sh"
  }

  provisioner "file" {
    source      = "ComputeNeutron.sh"
    destination = "ComputeNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ComputeNova.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh ${packet_device.controller.access_public_ipv4} ${packet_device.controller.access_private_ipv4} > ComputeNeutron.out",
    ]
  }
}
