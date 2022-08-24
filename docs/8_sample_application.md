> # ` Installing a sample application`

Now it is time to take your new cluster for a test drive. Sock Shop is a sample microservices application that shows how to run and connect a set of services on Kubernetes. To learn more about the sample microservices app, see the GitHub README.

`Note that the Sock Shop demo only works on amd64.`

```bash
kubectl create namespace sock-shop
kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"
```
> ### command output

    moop@devbox:~/Desktop/sysadmin_package$ kubectl create namespace sock-shop
    kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"
    namespace/sock-shop created
    Warning: resource namespaces/sock-shop is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
    namespace/sock-shop configured
    Warning: spec.template.spec.nodeSelector[beta.kubernetes.io/os]: deprecated since v1.14; use "kubernetes.io/os" instead
    deployment.apps/carts created
    service/carts created
    deployment.apps/carts-db created
    service/carts-db created
    deployment.apps/catalogue created
    service/catalogue created
    deployment.apps/catalogue-db created
    service/catalogue-db created
    deployment.apps/front-end created
    service/front-end created
    deployment.apps/orders created
    service/orders created
    deployment.apps/orders-db created
    service/orders-db created
    deployment.apps/payment created
    service/payment created
    deployment.apps/queue-master created
    service/queue-master created
    deployment.apps/rabbitmq created
    service/rabbitmq created
    deployment.apps/session-db created
    service/session-db created
    deployment.apps/shipping created
    service/shipping created
    deployment.apps/user created
    service/user created
    deployment.apps/user-db created
    service/user-db created

You can then find out the port that the NodePort feature of services allocated for the front-end service by running:

    kubectl -n sock-shop get svc front-end

Sample output:

    moop@devbox:~/Desktop/sysadmin_package$ kubectl -n sock-shop get svc front-end
    NAME        TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    front-end   NodePort   10.102.172.254   <none>        80:30001/TCP   91s

> # Accessing Services from a Browser
---
> URL of service is in the below format:

    <service-name>.<namespace>.svc.cluster.local:<service-port>

EXAMPLE:

    Name:                     front-end
    Namespace:                sock-shop
    Labels:                   name=front-end
    Annotations:              prometheus.io/scrape: true
    Selector:                 name=front-end
    Type:                     NodePort
    IP Family Policy:         SingleStack
    IP Families:              IPv4
    IP:                       10.97.199.233
    IPs:                      10.97.199.233
    Port:                     <unset>  80/TCP
    TargetPort:               8079/TCP
    NodePort:                 <unset>  30001/TCP
    Endpoints:                <none>
    Session Affinity:         None
    External Traffic Policy:  Cluster
    Events:                   <none>

    URL =  front-end.sock-shop.svc.cluster.local.30001

EXAMPLE 2

    Name:              bwapp-service
    Namespace:         default
    Labels:            <none>
    Annotations:       <none>
    Selector:          app=bwapp
    Type:              ClusterIP
    IP Family Policy:  SingleStack
    IP Families:       IPv4
    IP:                10.99.122.174
    IPs:               10.99.122.174
    Port:              <unset>  80/TCP
    TargetPort:        80/TCP
    Endpoints:         <none>
    Session Affinity:  None
    Events:            <none>

LOCATION:

    bwapp-service.default.svc.kubernetes.local:8082

> ### (required) forward to outside

    kubectl port-forward svc/bwapp-service 8082:80 -n default
