#Step 4: Get all Cluster Details & Secrets
#We will retrieve all the required kubeconfig details and save them in variables
#Then, finally, we will substitute it directly to the Kubeconfig YAML.

export SA_TOKEN_NAME=$(kubectl -n kube-system get serviceaccount devops-cluster-admin -o=jsonpath='{.secrets[0].name}')
export SA_SECRET_TOKEN=$(kubectl -n kube-system get secret/${SA_TOKEN_NAME} -o=go-template='{{.data.token}}' | base64 --decode)
export CLUSTER_NAME=$(kubectl config current-context)
export CURRENT_CLUSTER=$(kubectl config view --raw -o=go-template='{{range .contexts}}{{if eq .name "'''${CLUSTER_NAME}'''"}}{{ index .context "cluster" }}{{end}}{{end}}')
export CLUSTER_CA_CERT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}"{{with index .cluster "certificate-authority-data" }}{{.}}{{end}}"{{ end }}{{ end }}')
export CLUSTER_ENDPOINT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}{{ .cluster.server }}{{end}}{{ end }}')

#Step 5: Generate the Kubeconfig With the variables.

#If you execute the following YAML, all the variables get substituted and a 
#config named devops-cluster-admin-config gets generated.

cat << EOF > devops-cluster-admin-config
apiVersion: v1
kind: Config
current-context: ${CLUSTER_NAME}
contexts:
- name: ${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    user: devops-cluster-admin
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CLUSTER_CA_CERT}
    server: ${CLUSTER_ENDPOINT}
users:
- name: devops-cluster-admin
  user:
    token: ${SA_SECRET_TOKEN}
EOF