# dashboard

> location of the dashboard when `kubectl proxy` command is run
>`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

To install the dashboard for kubernetes, do this in the terminal (dashboard config lies in `PROJECT_ROOT/lib/yaml_repo/cluster_dashboard.yml`)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
kubectl proxy
```


## create a service account (use this)

>`save as ./create_service_account.yml`
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```
    kubectl apply -f ./{filename}

> kubectl apply -f ./create_admin_in_dashboard.yml 

## users / tokens

to log into a USEFUL dashboard
you do 

    # get list of users
    kubectl get serviceAccounts
    # get the token
    kubectl -n kubernetes-dashboard create token admin-user > ./token.txt

# url for dashboard

    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

## remove accounts
    
    kubectl -n kubernetes-dashboard delete serviceaccount admin-user
    kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

