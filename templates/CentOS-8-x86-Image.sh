export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

# Download image and upload into OpenStack (Glance)

IMG_URL=http://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
IMG_NAME=CentOS-8-x86_64
OS_DISTRO=centos
wget -q -O - $IMG_URL | \
openstack image create \
	--disk-format qcow2 --container-format bare \
        --property architecture=x86_64 \
	--public \
	$IMG_NAME
