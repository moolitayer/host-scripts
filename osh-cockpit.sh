# cockpit
yum install -y cockpit
systemctl enable --now cockpit.socket
# OepnShift uses firewalld
iptables -A OS_FIREWALL_ALLOW -p tcp -m tcp --dport 9090 -j ACCEPT
service iptables save

