#
#
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

openstack keypair create default > default.pem
chmod 400 default.pem

#
SEC_GROUP=`openstack security group create ssh-icmp -f value -c id`
openstack security group rule create --protocol icmp --ingress $SEC_GROUP
openstack security group rule create --dst-port 22 --protocol tcp --ingress $SEC_GROUP

#
# create an network
#
NETWORK_ID=`openstack network create sample-workload -f value -c id`
INTERNAL_SUBNET="192.168.100.0/24"

SUBNET_ID=`openstack subnet create              \
        --network ${NETWORK_ID}                   \
        --subnet-range $INTERNAL_SUBNET         \
        $INTERNAL_SUBNET -f value -c id`

GATEWAY_ID=`openstack router create gateway -f value -c id`

openstack router add subnet $GATEWAY_ID $SUBNET_ID
