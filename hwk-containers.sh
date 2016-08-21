systemctl start docker
systemctl enable docker

mkdir -p  /var/run/hawkular/cassandra
mkdir -p  /var/run/hawkular/hawkular
chcon -Rt svirt_sandbox_file_t /var/run/hawkular
docker run --detach --name myCassandra -e CASSANDRA_START_RPC=true -v /var/run/hawkular/cassandra:/var/lib/cassandra cassandra:3.7
docker run --detach -v /var/run/hawkular/hawkular:/opt/data -e HAWKULAR_BACKEND=remote -e CASSANDRA_NODES=myCassandra -p 8080:8080 -p 8443:8443 --link myCassandra:myCassandra pilhuhn/hawkular-services

# Grafana
docker run --privileged -d -p 3000:3000 -v /var/lib/grafana:/var/lib/grafana -e "GF_SECURITY_ADMIN_PASSWORD=secret"     yaacov/grafana-hawkular
