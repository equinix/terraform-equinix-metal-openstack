export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

# Download ARM images and upload into OpenStack (Glance)
IMG_URL=http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-aarch64-disk.img
IMG_NAME=Cirros-arm64
OS_DISTRO=cirros

wget -q -O - $IMG_URL | \
openstack image create \
	--disk-format qcow2 --container-format bare \
	--property hw_firmware_type=uefi \
        --property architecture=aarch64 \
	--public \
	$IMG_NAME
