#
#
export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

#
# create x86 machines with password based logins enabled
#
openstack server create \
	--flavor m1.tiny \
	--image Cirros-x86_64 \
	--key-name default \
        --security-group ssh-icmp \
        --network sample-workload \
	Cirros-x86

FLOATING_IP_ID=`openstack floating ip create provider -f value -c id`
openstack server add floating ip Cirros-x86 $FLOATING_IP_ID

openstack server create \
	--flavor m1.small \
	--image CentOS-8-x86_64 \
	--key-name default \
        --security-group ssh-icmp \
        --network sample-workload \
	--user-data userdata.txt \
	Centos-x86

FLOATING_IP_ID=`openstack floating ip create provider -f value -c id`
openstack server add floating ip Centos-x86 $FLOATING_IP_ID
