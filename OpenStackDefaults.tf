#
# load up the OpenStack cloud with some default settings and images
#
data "template_file" "CentOS-8-ARM-Image" {
  template = file("${path.module}/templates/CentOS-8-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-CentOS-8-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CentOS-8-ARM-Image.rendered
    destination = "CentOS-8-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CentOS-8-ARM-Image.sh > CentOS-8-ARM-Image.out",
    ]
  }
}

data "template_file" "CentOS-8-x86-Image" {
  template = file("${path.module}/templates/CentOS-8-x86-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-CentOS-8-x86" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-x86_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.CentOS-8-x86-Image.rendered
    destination = "CentOS-8-x86-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash CentOS-8-x86-Image.sh > CentOS-8-x86-Image.out",
    ]
  }
}

data "template_file" "Fedora-ARM-Image" {
  template = file("${path.module}/templates/Fedora-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Fedora-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Fedora-ARM-Image.rendered
    destination = "Fedora-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Fedora-ARM-Image.sh > Fedora-ARM-Image.out",
    ]
  }
}

data "template_file" "Cirros-x86-Image" {
  template = file("${path.module}/templates/Cirros-x86-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Cirros-x86" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-x86_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Cirros-x86-Image.rendered
    destination = "Cirros-x86-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Cirros-x86-Image.sh > Cirros-x86-Image.out",
    ]
  }
}

data "template_file" "Bionic-18_04-ARM-Image" {
  template = file("${path.module}/templates/Bionic-18_04-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Bionic-18_04-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Bionic-18_04-ARM-Image.rendered
    destination = "Bionic-18_04-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Bionic-18_04-ARM-Image.sh > Bionic-18_04-ARM-Image.out",
    ]
  }
}


data "template_file" "Bionic-18_04-x86-Image" {
  template = file("${path.module}/templates/Bionic-18_04-x86-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Bionic-18_04-x86" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-x86_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Bionic-18_04-x86-Image.rendered
    destination = "Bionic-18_04-x86-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Bionic-18_04-x86-Image.sh > Bionic-18_04-x86-Image.out",
    ]
  }
}

data "template_file" "Trusty-14_04-ARM-Image" {
  template = file("${path.module}/templates/Trusty-14_04-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Trusty-14_04-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Trusty-14_04-ARM-Image.rendered
    destination = "Trusty-14_04-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Trusty-14_04-ARM-Image.sh > Trusty-14_04-ARM-Image.out",
    ]
  }
}

data "template_file" "Xenial-16_04-ARM-Image" {
  template = file("${path.module}/templates/Xenial-16_04-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Xenial-16_04-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Xenial-16_04-ARM-Image.rendered
    destination = "Xenial-16_04-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Xenial-16_04-ARM-Image.sh > Xenial-16_04-ARM-Image.out",
    ]
  }
}

data "template_file" "Cirros-ARM-Image" {
  template = file("${path.module}/templates/Cirros-ARM-Image.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-image-Cirros-ARM" {
  depends_on = [null_resource.controller-glance]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.Cirros-ARM-Image.rendered
    destination = "Cirros-ARM-Image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash Cirros-ARM-Image.sh > Cirros-ARM-Image.out",
    ]
  }
}

data "template_file" "DefaultOpenStackFlavors" {
  template = file("${path.module}/templates/DefaultOpenStackFlavors.sh")

  vars = {
    ADMIN_PASS = random_password.os_admin_password.result
  }
}

resource "null_resource" "openstack-flavors" {
  depends_on = [null_resource.controller-nova,
  null_resource.controller-neutron]

  connection {
    host        = metal_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    content     = data.template_file.DefaultOpenStackFlavors.rendered
    destination = "DefaultOpenStackFlavors.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash DefaultOpenStackFlavors.sh > DefaultOpenStackFlavors.out",
    ]
  }
}

