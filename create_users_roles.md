##  `Create ServiceAccount per user`

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: NAME-user
  namespace: kubernetes-dashboard

    Adapt the RoleBinding adding this SA

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: PUT YOUR CR HERE
  namespace: PUT YOUR NS HERE
subjects:
  - kind: User
    name: PUT YOUR CR HERE
    apiGroup: 'rbac.authorization.k8s.io'
  - kind: ServiceAccount
    name: NAME-user
    namespace: kubernetes-dashboard
roleRef:
  kind: ClusterRole
  name: PUT YOUR CR HERE
  apiGroup: 'rbac.authorization.k8s.io'
```

##   `Get the token:`

    kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/NAME-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

## `Add token into your kubeconfig file. Your kb should be contain something like this:`

```yaml
apiVersion: v1
clusters:
- cluster:
    server: https://XXXX
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: YOUR UER
  name: kubernetes
current-context: "kubernetes"
kind: Config
preferences: {}
users:
- name: YOUR USER
  user:
    client-certificate-data: CODED
    client-key-data: CODED
    token: CODED  ---> ADD TOKEN HERE
```
    Login
