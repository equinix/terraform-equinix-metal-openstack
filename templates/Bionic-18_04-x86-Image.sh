export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

# Download image and upload into OpenStack (Glance)

IMG_URL=https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
IMG_NAME=Bionic-x86
OS_DISTRO=ubuntu

wget -q -O - $IMG_URL | \
openstack image create \
	--disk-format qcow2 --container-format bare \
	--property architecture=x86_64 \
	--public \
	$IMG_NAME
