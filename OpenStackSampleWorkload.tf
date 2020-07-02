#
# load up the cloud with some sample VMs and a network
#

resource "null_resource" "openstack-sample-workload-common" {
  depends_on = [
    null_resource.controller-nova,
    null_resource.controller-neutron,
    null_resource.compute-x86-openstack,
    null_resource.compute-arm-openstack,
    null_resource.controller-register-compute-hosts,
  ]

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "userdata.txt"
    destination = "userdata.txt"
  }

  provisioner "file" {
    source      = "SampleWorkloadCommon.sh"
    destination = "SampleWorkloadCommon.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash SampleWorkloadCommon.sh > SampleWorkloadCommon.out",
    ]
  }
}

resource "null_resource" "openstack-sample-workload-arm" {
  depends_on = [
    null_resource.openstack-sample-workload-common,
    null_resource.openstack-image-CentOS-8-ARM,
    null_resource.openstack-image-Fedora-ARM,
    null_resource.openstack-image-Cirros-ARM,
    null_resource.openstack-image-Trusty-14_04-ARM,
    null_resource.openstack-image-Xenial-16_04-ARM,
    null_resource.openstack-flavors,
    null_resource.enable-br-public,
    null_resource.controller-provider-networks,
  ]

  count = var.openstack_compute-arm_count == 0 ? 0 : 1

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "SampleWorkloadARM.sh"
    destination = "SampleWorkloadARM.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60; bash SampleWorkloadARM.sh > SampleWorkloadARM.out",
    ]
  }
}

resource "null_resource" "openstack-sample-workload-x86" {
  depends_on = [
    null_resource.openstack-sample-workload-common,
    null_resource.openstack-image-Bionic-18_04-x86,
    null_resource.openstack-image-Cirros-x86,
    null_resource.openstack-image-CentOS-8-x86,
    null_resource.openstack-flavors,
    null_resource.enable-br-public,
    null_resource.controller-provider-networks,
  ]

  count = var.openstack_compute-x86_count == 0 ? 0 : 1

  connection {
    host        = packet_device.controller.access_public_ipv4
    private_key = file(var.cloud_ssh_key_path)
  }

  provisioner "file" {
    source      = "SampleWorkloadx86.sh"
    destination = "SampleWorkloadx86.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60; bash SampleWorkloadx86.sh > SampleWorkloadx86.out",
    ]
  }
}
