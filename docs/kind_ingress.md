# Load nginx pod in KIND

The yaml file necessary for an nginx ingress cluster is as follows

>`nginx_cluster.yml`
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"        
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
```

>This configuration will expose port 80 and 443 on the host. It’ll also add a node label so that the nginx-controller may use a node selector to target only this node. If a kind configuration has multiple nodes, it’s essential to only bind ports 80 and 443 on the host for one node because port collision will occur otherwise.

Save that file as whatever name you wish, then create a kind cluster using this config file via:

```bash
# yaml file is in ./lib/yaml_repo/kube_ingress_nginx.yml
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s
```

# test nginx

```bash
kubectl run hello --expose --image nginxdemos/hello:plain-text --port 80
```
Then create an Ingress resource that directs traffic to the service by creating a file named ingress.yaml with the following content:

>`ingress.yml`
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ctf
spec:
  rules:
    - host: ctf.devbox.local
      http:
        paths:
          - pathType: ImplementationSpecific
            backend:
              service:
                name: ctf
                port:
                  number: 80
``` 




## Deploy the Ingress resource by running:
```bash
kubectl create --filename ./lib/yaml_repo/ingress.yml
```
# request ingress endpoint from Docker container
```bash
docker run --add-host hello.devbox.local:172.18.0.2 --net kind --rm curlimages/curl:7.71.0 hello.devbox.local
```

## request ingress endpoint from host, manual method

We can modify /etc/hosts on the host to direct traffic to the kind cluster’s ingress controller. 
This approach works on Linux. The next section will cover how to use a Docker container, 
which will work on Mac and Windows.

We’ll need to get the IP address of our kind node’s Docker container first by running:
 
>`docker container inspect kind-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}'`

Then add an entry to /etc/hosts with the IP address found that looks like:

    172.18.0.2 hello.devbox.local

Finally, we can curl hello.dustinspecker.com:

    curl hello.devbox.local

>Note: --net kind connects this docker container to the same Docker network that the kind cluster is on.


# KIND: create nginx based ingress controller

The manifests contains kind specific patches to forward the hostPorts to the ingress controller, set taint tolerations and schedule it to the custom labelled node.

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`

    moop@devbox:~/Desktop/sysadmin_package$ kubectl apply -f ./lib/yaml_repo/kind_ingress_nginx.yml
    namespace/ingress-nginx created
    serviceaccount/ingress-nginx created
    serviceaccount/ingress-nginx-admission created
    role.rbac.authorization.k8s.io/ingress-nginx created
    role.rbac.authorization.k8s.io/ingress-nginx-admission created
    clusterrole.rbac.authorization.k8s.io/ingress-nginx created
    clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
    rolebinding.rbac.authorization.k8s.io/ingress-nginx created
    rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
    clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
    clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
    configmap/ingress-nginx-controller created
    service/ingress-nginx-controller created
    service/ingress-nginx-controller-admission created
    deployment.apps/ingress-nginx-controller created
    job.batch/ingress-nginx-admission-create created
    job.batch/ingress-nginx-admission-patch created
    ingressclass.networking.k8s.io/nginx created
    validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created


Now the Ingress is all setup. Wait until is ready to process requests running:

    kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s

