#!/bin/bash

cat << EOF > /usr/local/sbin/get_zabbix_ospf_routes_number
#!/bin/bash
vtysh -c 'show ip route ospf' | wc -l > /tmp/zabbix_ospf_routes_number
EOF

chmod 0755 /usr/local/sbin/get_zabbix_ospf_routes_number

cat << EOF > /tmp/zabbix_ospf_routes_number_cron.sh
#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
set system task-scheduler task zabbix_ospf_routes_number executable path /usr/local/sbin/get_zabbix_ospf_routes_number
set system task-scheduler task zabbix_ospf_routes_number crontab-spec "* * * * *"
commit
save
EOF

chmod 0700 /tmp/zabbix_ospf_routes_number_cron.sh
/tmp/zabbix_ospf_routes_number_cron.sh
rm -f /tmp/zabbix_ospf_routes_number_cron.sh
