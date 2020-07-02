# OpenStack on Packet Installation Guide

![Terraform](https://github.com/packet-labs/OpenStackOnPacket/workflows/Terraform/badge.svg)


## Overview

Use Terraform to quickly and easily create an OpenStack cloud powered by Armv8 and/or x86 bare metal servers at Packet. Specifically, this deployment showcases how a multi-node cloud can be deployed on Packet bare metal.

This repo has multiple branches, one for each OpenStack release.  The following OpenStack releases are supported:
* [Train](https://www.openstack.org/software/train/)
* [Ussuri](https://www.openstack.org/software/ussuri/)

The deployment defaults to a minimum 3 node OpenStack cloud, consisting of 2 x86 infrastructure nodes and a single x86 node compute node. 
 
- It is possible to modify the total number of nodes and the type (various sizes of x86 and ARM hardware provided by Packet). 
- By default, the template uses third generation Packet hardware.

If you require support, please email [support@packet.com](mailto:support@packet.com), visit the Packet IRC channel (#packethost on freenode), subscribe to the [Packet Community Slack channel](https://slack.packet.com) or post an issue within this repository.

Contributions are welcome to help extend this work!

## Cloud Abilities

The default deployment supports both ARM and x86 based virtual workloads across multiple compute nodes. Inter-node communication is setup allowing virtual machines within the same overlay network but on different compute nodes to communicate with each other across underlying VXLAN networks. This is a transparent capability of OpenStack. Management and inter-node traffic travers the private Packet project network (10 subnet). Public OpenStack services are available via the public IP addresses assigned by Packet. DNS is not setup as part of this deployment so use IP addresses to access the services. The backend private IP addresses are mapped automatically into the node hostfiles via the deployment process.

The virtual machine images are deployed with enabled usernames and passwords allowing console login. For more details please see "userdata.txt", the cloud-init file that is used for the CentOS, Fedora, and Ubuntu virtual machines. The Cirros default login information is displayed on the console when logging in. The controller and compute nodes are configured with VNC console access for all the x86 machines. Console access is via the Horizon GUI dashboard. Since the ARM virtual machines do not support VNC console access, novaconsole has been made available on the controller via CLI.

By default, upstream connectivity from inside the cloud (virtual machines/networks) to the Internet is not enabled. Connectivity within internal virtual networks is enabled. The sample workload has SSH (TCP-22) and ICMP traffic enabled via security groups.

## Prerequisites

### Packet Project ID & API Key

This deployment requires a Packet account for the provisioned bare metal. You'll need your "Packet Project ID" and your "Packet API Key" to proceed. You can use an existing project or create a new project for the deployment.

We recommend setting the Packet API Token and Project ID as environment variables since this prevents tokens from being included in source code files. These values can also be stored within a variables file later if using environment variables isn't desired.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

#### Where is my Packet Project ID?

You can find your Project ID under the 'Manage' section in the Packet Portal. They are listed underneath each project in the listing. You can also find the project ID on the project 'Settings' tab, which also features a very handy "copy to clipboard" piece of functionality, for the clicky among us.

#### How can I create a Packet API Key? 

You will find your API Key on the left side of the portal. If you have existing keys you will find them listed on that page. If you haven't created one yet, you can click here:

https://app.packet.net/portal#/api-keys/new

#### Ensure that your Packet account has an SSh key attached
When provisioning the machines, Packet will preset an SSH key to allow administrative access. If no SSH keys are available, it will fail with a "Must have at least one SSH key" error. To fix this, add an ssh key in you Packet account.

### Terraform

These instructions use Terraform from Hashicorp to drive the deployment. If you don't have Terraform installed already, you can download and install Terraform using the instructions on the link below:
https://www.terraform.io/downloads.html

## Deployment Prep

Download the OpenStackOnPacket manifests from GitHub into a local directory.

```bash
git clone URL_TO_REPO
cd OpenStackOnPacket
```

From that directory, generate an ssh keypair or copy an existing public/private keypair (packet-key and packet-key.pub).

```bash
ssh-keygen -N "" -t rsa -f ./packet-key
```

Download the Terraform providers required:
```bash
terraform init
```

## Cloud Sizing Defaults

Several configurations files are available each building the cloud with a different mix of hardware architectures and capacity.


| Filename                      | Description         | Controller    | Dashboard     | x86 Compute Nodes| ARM Compute Nodes| 
| :----------                   | :--------------     | :------------ | :------------ | :--------------- | :--------------- |
| default                       | Minimal Config      | c3.medium.x86 | c3.medium.x86 | c3.medium.x86    | none             |
| sample.terraform.tfvars       | ARM & x86 compute   | c2.medium.x86 | c2.medium.x86 | n2.xlarge.x86    | c2.large.arm     |
| sample-arm.terraform.tfvars   | Packet Gen 2 ARM    | c2.large.arm  | c2.large.arm  | none             | c2.large.arm     |
| sample-gen2.terraform.tfvars  | Packet Gen 2 x86    | c2.medium.x86 | c2.medium.x86 | n2.xlarge.x86    | none             |
| sample-gen3.terraform.tfvars  | Packet Gen 3 x86    | c3.medium.x86 | c3.medium.x86 | s3.xlarge.x86    | none             |

Running without a "terraform.tfvars" will result in the "default" configuration using Packet c2.medium.x86 hardware devices
and no ARM capabilities. The other sample configurations deploy a mix of ARM and x86 hardware across different Packet hardware generations.

There are a number of defaults that can be modified as desired. Any deviations from the defaults can be set in terraform.tfvars. No modifications to defaults are required except for the Packet Project ID and API Token if not set as environment variables.

Copy over the sample terraform settings:
```bash
cp sample.terraform.tfvars terraform.tfvars
``` 

If the Packet API Token and Project ID were not saved as environment variables then they'll need to be stored in the terraform.tfvars.

| Name        | Software               | Default Count | Minimum Count | 
| :---------- | :----------------------| -------------:| -------------:|
| Controller  | Keystone, Glance, Nova | 1             | 1             |
| Dashboard   | Horizon                | 1             | 0 or more     |
| Compute x86 | Neutron                | 1             | 0 or more     |


In terraform.tfvars, the type of all these nodes can be changed. The size of the cloud can also be grown by increasing the count of ARM and x86 compute nodes above the default count of 1. A count of 0 of any compute node type (ARM or x86) will render the cloud unable to provision virtual machines of said type. While this deployment will cluster and support multiple compute nodes, it does not support multiple controller or dashboard nodes.

## Deployment

Start the deployment:
```bash
terraform apply
```

At the conclusion of the deployment, the final settings will be displayed. These values can also be output:

```bash
terraform output
```

Sample output as follows:
```
Cloud_ID_Tag = 2dd4409b
Compute_ARM_IPs = []
Compute_ARM_Type = []
Compute_x86_IPs = [
  "147.75.65.85",
]
Compute_x86_Type = [
  "n2.xlarge.x86",
]
Controller_SSH = ssh root@147.75.75.90 -i ./packet-key
Controller_Type = c2.medium.x86
Horizon_dashboard_via_IP = http://147.75.64.78/horizon/ username/password
```

The OpenStack Horizon dashboard can be pulled up at the URL listed with the username/password provided.
The OpenStack Controller (CLI) can be accessed at the SSH address listed with the key provided.


## Sample Workload

This deployment includes the following additional items in addition atop of the OpenStack installation. This includes a set of virtual machine images (Cirros, CentOS, Fedora, Ubuntu), a virtual network and some running virtual machines. For more information on the deployed workloads, please see:

https://github.com/PacketLabs/OpenStackOnPacket/blob/master/SampleOpenStackWorkload.sh


## Validation
The deploy can be verified via the OpenStack CLI and/or via the OpenStack GUI (Horizon). The CLI commands can be run on the Contoller node (via SSH). The GUI commands are run on a web browser using the URL and credentials output by Terraform. The individual CLI commands and GUI drill down paths are listed below. This validation checks that all the compute nodes are running and the same workload virtual machines images are running.

When running the CLI, the OpenStack credentials need to be setup by reading in the openrc file.

* Setup the OpenStack credentials
```bash
source admin-openrc
```

* Validate that all the OpenStack compute services are running. There will be one nova-compute per bare metal compute node provisioned (ARM or x86).
* Horizon: Admin->System Information->Compute Services
```
root@controller:~# openstack compute service list
+----+----------------+----------------+----------+---------+-------+----------------------------+
| ID | Binary         | Host           | Zone     | Status  | State | Updated At                 |
+----+----------------+----------------+----------+---------+-------+----------------------------+
|  1 | nova-conductor | controller     | internal | enabled | up    | 2020-04-10T22:34:31.000000 |
| 10 | nova-scheduler | controller     | internal | enabled | up    | 2020-04-10T22:34:32.000000 |
| 16 | nova-compute   | compute-x86-00 | nova     | enabled | up    | 2020-04-10T22:34:39.000000 |
+----+----------------+----------------+----------+---------+-------+----------------------------+
```

* Validate that all the images have been installed
* Horizon: Admin->Compute->Images
```
root@controller:~# openstack image list
+--------------------------------------+-----------------+--------+
| ID                                   | Name            | Status |
+--------------------------------------+-----------------+--------+
| 2f873bcc-e4ef-471d-a413-6c7bd17c6be0 | Bionic-amd64    | active |
| bc1cac00-996a-4d69-be24-dcdcbc80b812 | Bionic-arm64    | active |
| 4928c2c6-a27d-4e0f-ad71-746ee6d6ab3d | CentOS-8-arm64  | active |
| 6bbb17d2-16df-45a9-bd68-70e89147996c | CentOS-8-x86_64 | active |
| 0c41cdcb-0f8e-488c-9732-4f549aafe640 | Cirros-arm64    | active |
| 68368d34-48d0-4b47-85d4-990457621f97 | Cirros-x86_64   | active |
| 039a1fff-f9d7-45b5-af6f-76c7c0e6f2d3 | Fedora-32-arm64 | active |
| ef2958fc-5ad0-4780-8d1f-0900eaeedf22 | Trusty-arm64    | active |
| 8708ae1b-210d-4bff-8547-93be0c787072 | Xenial-arm64    | active |
+--------------------------------------+-----------------+--------+

```

* Validate that all the x86 compute node has the appropriate number of vCPUs and memory
```
root@controller:~# openstack hypervisor show compute-x86-00 -f table -c service_host -c vcpus -c memory_mb -c running_vms
+--------------+----------------+
| Field        | Value          |
+--------------+----------------+
| memory_mb    | 385434         |
| running_vms  | 1              |
| service_host | compute-x86-00 |
| vcpus        | 56             |
+--------------+----------------+
```

* Validate that all the virtual machines are running
* Horizon: Admin->Compute->Instances
```
root@controller:~# openstack server list
+--------------------------------------+------+--------+---------------------------+---------------+-----------+
| ID                                   | Name | Status | Networks                  | Image         | Flavor    |
+--------------------------------------+------+--------+---------------------------+---------------+-----------+
| 841ab626-9ad9-492c-ad83-ecdf0d8680b8 | foo  | ACTIVE | 192.168.0.0=192.168.0.116 | Cirros-x86_64 | m1.medium |
+--------------------------------------+------+--------+---------------------------+---------------+-----------+
```

## Serial Console Support

Access to the serial console is available via the "novaconsole" application installed from the controller node. The OpenStack CLI can be used to general a URL with a valid token to access the console.

```bash
source admin-openrc
openstack console url show --serial Xenial-arm64
```

The provided URL can then be passed to the novaconsole command to pull up the serial console.

```bash
novaconsole --url ws://157.75.79.194:6083/?token=18510769-71ad-4e5a-8348-4218b5613b3d
```

Root logins and cloud account logins (centos/ubuntu) are permited using the password in userdata.txt. The cirros default logins are enabled by default.

The two commands can be combined into one as shown below:

```bash
novaconsole --url `openstack console url show --serial Cirros-x86 -f value -c url`
```


## External Networking Support

External (Provider) networking allows VMs to be assigned Internet addressable floating IPs. This allows the VMs to offer Internet accessible services (i.e. SSH and HTTP). This requires the a block of IP addresses from Packet (elastic IP address). These can be requested through the Packet Web GUI. Please see https://support.packet.com/kb/articles/elastic-ips for more details. Public IPv4 of at least /29 is recommended. A /30 will provide only a single floating IP. A /29 allocation will provide 5 floating IPs.

Once the Terraform has finished, the following steps are required to enable the external networking.

* Assign the elastic IP subnet to the "Controller" physical host via the Packet Web GUI.
* Log into the Controller physical node via SSH and execute:

```
sudo bash ExternalNetwork.sh <ELASTIC_CIDR>
```

For example, if your CIDR subnet is 10.20.30.0/24 the command would be:
```
sudo bash ExternalNetwork.sh 10.20.30.0/24
```

From there, assign a floating IPs via the dashboard and update security groups to permit the desired ports.

## External Block Storage

Packet offeres block storage that can be attached to compute nodes and used as ephemeral storage for VMs. This involves creating the storage via the Packet Web App, associating the storage with a compute node, and setting up the volume within the compute node. In this example, a 1TB volume is being created for use as ephemeral storage.

# Stop the OpenStack Nova Compute service
```
service nova-compute stop
```

# Create and assign a storage volume

Create the volume via the Packet Web App and assign to the compute node.
See the steps at: https://support.packet.com/kb/articles/elastic-block-storage

```
apt-get -y install jq
packet-block-storage-attach
fdisk /dev/mapper/volume-YOUR_ID_HERE # create a new volume (n) and accept defaults
mkfs.ext4 /dev/mapper/volume-YOUR_ID_HERE-part1
blkid | grep volume-YOUR_ID_HERE-part1 # take note of the UUID
```

# Copy over the existing Nova data

```
mnt /dev/mapper/volume-YOUR_ID_HERE /mnt
rsync -avxHAX --progress /var/lib/nova/ /mnt 
umount /mnt
rm -rf /var/lib/nova/*
vi /etc/fstab # add a line like UUID=YOUR-UUID-HERE /var/lib/nova ext4 0 2
mount -a
```

# Start the OpenStack Nova Compute service
```
service nova-compute start
```

# Tearing it all down

To decommission a compute node, the above steps must be done in reverse order.

```
umount /var/lib/nova
packet-block-storage-deatach
```

Via the Packet Web App, detach the volume from the host, and then delete the volume. The physical host can then be deprovisioned via Terraform destroy.

