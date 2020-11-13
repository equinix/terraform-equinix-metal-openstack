# Compute Only Below


# private IP addr (10...)
MY_PRIVATE_IP=`hostname -I | xargs -n1 2>/dev/null | grep "^10\." | head -1`
MY_PUBLIC_IP=`hostname -I | xargs -n1 2>/dev/null | head -1`

# bridge networking
modprobe br_netfilter

apt-get -y install nova-compute
apt-get -y install neutron-linuxbridge-agent

# compute server doesn't use a database so remove entire section
crudini --del /etc/neutron/neutron.conf database

crudini --set /etc/neutron/neutron.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller
crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone

crudini --set /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers controller:11211
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_type password
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken password NEUTRON_PASS

crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp

# provider networking

crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini linux_bridge physical_interface_mappings provider:bond0

crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan enable_vxlan true
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan local_ip ${MY_PUBLIC_IP}
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan l2_population true

crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup enable_security_group true
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

# end of provider networking

crudini --set  /etc/nova/nova.conf neutron auth_url http://controller:5000
crudini --set  /etc/nova/nova.conf neutron auth_type password
crudini --set  /etc/nova/nova.conf neutron project_domain_name default
crudini --set  /etc/nova/nova.conf neutron user_domain_name default
crudini --set  /etc/nova/nova.conf neutron region_name RegionOne
crudini --set  /etc/nova/nova.conf neutron project_name service
crudini --set  /etc/nova/nova.conf neutron username neutron
crudini --set  /etc/nova/nova.conf neutron password NEUTRON_PASS

service nova-compute restart
service neutron-linuxbridge-agent restart

# end of neutron
