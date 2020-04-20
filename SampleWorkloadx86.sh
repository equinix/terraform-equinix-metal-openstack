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
# create x86 machines with password based logins enabled
#
openstack server create \
	--flavor m1.tiny \
	--image Cirros-x86_64 \
	--key-name default \
        --security-group ssh-icmp \
	Cirros-x86

openstack server create \
	--flavor m1.small \
	--image CentOS-8-x86_64 \
	--key-name default \
        --security-group ssh-icmp \
	--user-data userdata.txt \
	Centos-x86

