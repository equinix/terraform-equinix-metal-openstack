#
#
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

#timeout 300s bash -c 'until openstack server list; do sleep 5; echo waiting for services...; done'
#
# create ARM machines with password based logins enabled
#
openstack server create \
	--flavor m1.small \
	--image Trusty-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Trusty-arm64

openstack server create \
	--flavor m1.small \
	--image Bionic-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Bionic-arm64

openstack server create \
	--flavor m1.small \
	--image CentOS-8-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Centos-arm64

openstack server create \
	--flavor m1.small \
	--image Xenial-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Xenial-arm64

openstack server create \
	--flavor m1.small \
	--image Fedora-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Fedora-arm64

openstack server create \
	--flavor m1.tiny \
	--image Cirros-arm64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Cirros-arm64
