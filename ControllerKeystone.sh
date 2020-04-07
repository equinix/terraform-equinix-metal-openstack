# Controller Only Below

# private IP addr (10...)
MY_IP=`hostname -I | xargs -n1 | grep "^10\." | head -1`


## memcached
apt-get -y install memcached python-memcache
# set the IP where memchaced is listening
sed -i '/^-l.*/c\-l '$MY_IP /etc/memcached.conf
service memcached restart
## end of memcached

## mysql
apt-get -y install mariadb-server python-pymysql

cat > /etc/mysql/mariadb.conf.d/99-openstack.cnf << EOF
[mysqld]
bind-address = ${MY_IP}

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF

service mysql restart

# harden MySQL
# mysql_secure_installation
## end of mysql

## rabbitmq
apt-get -y install rabbitmq-server
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
## end of rabbitmq

## etcd
apt install -y etcd

cat > /etc/default/etcd << EOF
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://${MY_IP}:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://${MY_IP}:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://${MY_IP}:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://${MY_IP}:2379"
EOF

systemctl enable etcd
systemctl start etcd
## end of etcd

## keystone
mysql --batch -e "\
CREATE DATABASE keystone; \
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS'; \
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS'; \
FLUSH PRIVILEGES;"

# Keystone Packages
apt-get -y install keystone  apache2 libapache2-mod-wsgi

crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
crudini --set /etc/keystone/keystone.conf token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

echo "ServerName controller" >> /etc/apache2/apache2.conf
service apache2 restart

# replaces sourcing admin-openrc
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
 
openstack project create --domain default \
  --description "Service Project" service
  
openstack project create --domain default \
  --description "Demo Project" demo
  
openstack user create --domain default \
  --password DEMO_PASS demo
  
openstack role create user

openstack role add --project demo --user demo user

# small sanity check

# replaces sourcing admin-openrc
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack token issue

if [ $? -ne 0 ]; then
  echo "issues generating a keystone token"
else
  echo "successfully issued a keystone token"
fi
## end of keystone




