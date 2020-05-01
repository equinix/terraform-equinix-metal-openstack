#
# associate elastic IP subnet with the controller node via the Packet Web GUI
#

export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

PROVIDER_4_CIDR="${provider_ipv4_cidr}"
PROVIDER_6_CIDR="${provider_ipv6_cidr}"

export PROVIDER_4_ID=`openstack network create --share \
    --provider-physical-network provider \
    --provider-network-type flat provider \
    --external \
    -f value -c id`

echo "Provider 4 ID is $PROVIDER_4_ID"

export SUBNET_4_ID=`openstack subnet create \
    --network $PROVIDER_4_ID \
    --subnet-range $PROVIDER_4_CIDR \
    $PROVIDER_4_CIDR -f value -c id`

echo "Subnet 4 ID is $SUBNET_4_ID"

# assign this gateway to all routers
for ROUTER_ID in `openstack router list -f value -c ID`
do
openstack router set --external-gateway $PROVIDER_4_ID $ROUTER_ID
done
