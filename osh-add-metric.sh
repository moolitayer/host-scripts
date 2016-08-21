# Switch to the openshift-infra project
# todo remove!
oc project openshift-infra

# Create a metrics-deployer service account
oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API

# Grante the edit permission for the openshift-infra project
oadm policy add-role-to-user \
    edit system:serviceaccount:openshift-infra:metrics-deployer

# Grante the cluster-reader permission for the Heapster service account
oadm policy add-cluster-role-to-user \
    cluster-reader system:serviceaccount:openshift-infra:heapster

# Using Generated Self-Signed Certificates
oc secrets new metrics-deployer nothing=/dev/null

# Deploying metrics without Persistent Storage
wget https://raw.githubusercontent.com/openshift/origin-metrics/master/metrics.yaml
oc new-app -f metrics.yaml -p USE_PERSISTENT_STORAGE=false -p HAWKULAR_METRICS_HOSTNAME=$(hostname)

oc project default
