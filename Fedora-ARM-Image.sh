export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

# Download ARM images and upload into OpenStack (Glance)

IMG_URL=https://download.fedoraproject.org/pub/fedora/linux/releases/test/32_Beta/Cloud/aarch64/images/Fedora-Cloud-Base-32_Beta-1.2.aarch64.qcow2
IMG_NAME=Fedora-arm64
OS_DISTRO=fedora
wget -q -O - $IMG_URL | \
openstack image create \
	--disk-format qcow2 --container-format bare \
	--property hw_firmware_type=uefi \
        --property architecture=aarch64 \
	--public \
	$IMG_NAME
