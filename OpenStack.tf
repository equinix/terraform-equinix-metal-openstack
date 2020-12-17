resource "random_password" "os_admin_password" {
  length  = 16
  special = false
}

data "template_file" "CommonServerSetup" {
  template = file("${path.module}/templates/CommonServerSetup.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

data "template_file" "ControllerKeystone" {
  template = file("${path.module}/templates/ControllerKeystone.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "controller-keystone" {
  depends_on = [null_resource.hostfile-distributed]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
    destination = "CommonServerSetup.sh"
  }

  provisioner "file" {
    content     = data.template_file.ControllerKeystone.rendered
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
data "template_file" "ControllerGlance" {
  template = file("${path.module}/templates/ControllerGlance.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "controller-glance" {
  depends_on = [null_resource.controller-keystone]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.ControllerGlance.rendered
    destination = "ControllerGlance.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerGlance.sh > ControllerGlance.out",
    ]
  }
}

data "template_file" "ControllerNova" {
  template = file("${path.module}/templates/ControllerNova.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "controller-nova" {
  depends_on = [null_resource.controller-glance]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.ControllerNova.rendered
    destination = "ControllerNova.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerNova.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ControllerNova.out",
    ]
  }
}

data "template_file" "ControllerNeutron" {
  template = file("${path.module}/templates/ControllerNeutron.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "controller-neutron" {
  depends_on = [null_resource.controller-nova,
  null_resource.enable-br-public]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.ControllerNeutron.rendered
    destination = "ControllerNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ControllerNeutron.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ControllerNeutron.out",
    ]
  }
}

resource "null_resource" "dashboard-install" {
  depends_on = [null_resource.hostfile-distributed]

  connection {
    host        = metal_device.dashboard.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
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
    host        = metal_device.dashboard.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/assets/local_settings.py"
    destination = "/etc/openstack-dashboard/local_settings.py"
  }

  provisioner "file" {
    source      = "${path.module}/assets/Metal-splash.svg"
    destination = "/var/lib/openstack-dashboard/static/dashboard/img/logo-splash.svg"
  }

  provisioner "file" {
    source      = "${path.module}/assets/Metal-logo.svg"
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
    host        = element(metal_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
    destination = "CommonServerSetup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CommonServerSetup.sh > CommonServerSetup.out",
    ]
  }
}

data "template_file" "ComputeNova" {
  template = file("${path.module}/templates/ComputeNova.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

data "template_file" "ComputeNeutron" {
  template = file("${path.module}/templates/ComputeNeutron.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "compute-x86-openstack" {
  depends_on = [null_resource.compute-x86-common]

  count = var.openstack_compute-x86_count

  connection {
    host        = element(metal_device.compute-x86.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
    destination = "ComputeNova.sh"
  }

  provisioner "file" {
    content     = data.template_file.ComputeNeutron.rendered
    destination = "ComputeNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ComputeNova.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ComputeNeutron.out",
    ]
  }
}

resource "null_resource" "compute-arm-common" {
  depends_on = [null_resource.hostfile-distributed]

  count = var.openstack_compute-arm_count

  connection {
    host        = element(metal_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
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
    host        = element(metal_device.compute-arm.*.access_public_ipv4, count.index)
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CommonServerSetup.rendered
    destination = "ComputeNova.sh"
  }

  provisioner "file" {
    content     = data.template_file.ComputeNeutron.rendered
    destination = "ComputeNeutron.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ComputeNova.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ComputeNova.out",
      "bash ComputeNeutron.sh ${metal_device.controller.access_public_ipv4} ${metal_device.controller.access_private_ipv4} > ComputeNeutron.out",
    ]
  }
}

#
# once all the compute hosts are online have them registered by the controller
# this eliminates the need to wait the timeout internal in discover_hosts_in_cells_internal
#
resource "null_resource" "controller-register-compute-hosts" {
  depends_on = [null_resource.compute-arm-openstack,
    null_resource.compute-x86-openstack,
    null_resource.controller-neutron,
  null_resource.controller-nova]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "nova-manage cell_v2 discover_hosts",
    ]
  }
}
