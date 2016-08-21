secret=`oc get -n management-infra sa/management-admin --template='{{range .secrets}}{{printf "%s\n" .name}}{{end}}' | grep management-admin-token | head -n 1`; oc get -n management-infra secrets $secret --template='{{.data.token}}' | base64 -d > token.txt; cat token.txt; echo

