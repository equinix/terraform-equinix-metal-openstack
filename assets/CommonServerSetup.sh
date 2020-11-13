# General setup - applies to Controller and Compute

# sanity check - make sure we can reach the controller
ping controller -c 5 -q
if [ $? -ne 0 ] ; then
  echo "controller is unreachable via ping"
  echo "check /etc/hosts and networking"
fi

# private IP addr (10...)
MY_IP=`hostname -I | xargs -n1 2>/dev/null | grep "^10\." | head -1`

# disable restart prompts
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
export DEBIAN_FRONTEND=noninteractive

# general system updates
apt-get -y update
apt-get -y -o Dpkg::Options::='--force-confold' upgrade

apt-get install -y tzdata
timedatectl set-timezone UTC
dpkg-reconfigure --frontend noninteractive tzdata

# OpenStack needs precise time services
apt-get -y install chrony
service chrony restart

# OpenStack Ussuri for Ubuntu 18.04 LTS
add-apt-repository -y cloud-archive:ussuri
apt-get -y update

# Client for Ubuntu 18.04 LTS
apt-get -y install python3-openstackclient

# easy modification of .ini configuration files
apt-get -y install crudini

# setup bridge networking for provider networks
apt-get -y install bridge-utils


  
cat >> admin-openrc << EOF
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
EOF

cat >> demo-openrc << EOF
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
