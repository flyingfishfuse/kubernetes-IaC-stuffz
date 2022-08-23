
# managing your cluster with kubeadm, kubectl, and nerdctl

>## `Get dasdhboard token and save to file`
```bash
kubectl -n kubernetes-dashboard create token admin-user > ./token.txt
```

> ## `To delete everything from a namespace`
```bash
kubectl delete all --all -n {namespace_name}```


> ## `List all contexts`
```bash
kubectl config get-contexts
```

> ## `Set context`
```bash
kubectl set-context {context}
```

> ## `remove all docker containers`
```bash
docker rm $(docker ps -a -q)
```

> ## `remove docker images`
```bash
docker rmi $(docker images -q)
```

> ## `STOP all docker containers`
```bash
docker kill $(docker ps -q)
```

> ## `get all namespace information`
```bash
kubectl get all --all-namespaces
```
> ## `get all pods from specified namespace `
```bash
kubectl get pods --all-namespaces
```
========================================
# recreate kubeadm init's join command

> ## `Step 1: Retrieve Token CA Hash`
```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
    | openssl rsa -pubin -outform der 2>/dev/null \
    | openssl dgst -sha256 -hex \
    | sed 's/^.* //'
```

> ## `Step 2: Retrieve bootstrap Tokens`
```bash
kubeadm token list
```
> ## `Step 3: Create kubeadm init command`

use following syntax to create join command without creating a new token:
```bash
kubeadm join <ip-address>:6443\
    --token=<token-from-step-2> \
    --discovery-token-ca-cert-hash sha256:<ca-hash-from-step-1>
```
========================================
> ## `(Optional) Proxying API Server to localhost`
If you want to connect to the API Server from outside the cluster you can use kubectl proxy:

```bash
scp root@<control-plane-host>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf proxy
```

> # `COMPLETE PURGE AND RESET OF CLUSTER SOFTWARE`
```bash
#!/bin/sh
# Kube Admin Reset
sudo kubeadm reset

# Remove all packages related to Kubernetes
sudo apt remove -y kubeadm kubectl kubelet kubernetes-cni 
sudo apt purge -y kube*

apt autoremove -y

# Remove all folder associated to kubernetes, etcd, and docker
sudo rm -rf ~/.kube
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/etcd /var/lib/kubelet /var/lib/etcd2/ /var/run/kubernetes ~/.kube/* 
docker image prune -a
sudo systemctl restart docker
# Clear the iptables
sudo iptables -F && iptables -X
sudo iptables -t nat -F && iptables -t nat -X
sudo iptables -t raw -F && iptables -t raw -X
sudo iptables -t mangle -F && iptables -t mangle -X

# now for docker, do not run these if you are not performing a full reset, kubernetes can be reset with the above lines
# Remove docker containers/ images ( optional if using docker)
docker image prune -a
systemctl restart docker
apt purge -y docker-engine docker docker.io docker-ce docker-ce-cli containerd containerd.io runc --allow-change-held-packages

rm -rf /var/lib/docker /etc/docker /var/run/docker.sock /var/lib/dockershim
rm -f /etc/apparmor.d/docker /etc/systemd/system/etcd* 

# Remove parts

apt autoremove -y

# Delete docker group (optional)
groupdel docker

# Clear the iptables
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t raw -F && iptables -t raw -X
iptables -t mangle -F && iptables -t mangle -X
```

>## ``
```bash
```
>## `Getting service information`


> COMMAND: `kubectl describe service`

```bash
moop@devbox:~$ kubectl describe service
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


Name:              kubernetes
Namespace:         default
Labels:            component=apiserver
                   provider=kubernetes
Annotations:       <none>
Selector:          <none>
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.0.1
IPs:               10.96.0.1
Port:              https  443/TCP
TargetPort:        6443/TCP
Endpoints:         192.168.47.128:6443
Session Affinity:  None
Events:            <none>

```

>## `Running kubeadm without an Internet connection`

For running kubeadm without an Internet connection you have to pre-pull the required control-plane images.

You can list and pull the images using the kubeadm 
```bash
kubeadm config images list
kubeadm config images pull
```


>## ``
```bash
```
>## ``
```bash
```
>## ``
```bash
```
>## ``
```bash
```
>## ``
```bash
```
>## ``
```bash
```
>## ``
```bash
```
---
# Clean up
---
If you used disposable servers for your cluster, for testing, you can switch those off and do no further clean up. You can use kubectl config delete-cluster to delete your local references to the cluster.

However, if you want to deprovision your cluster more cleanly, you should first drain the node and make sure that the node is empty, then deconfigure the node.
Remove the node

> Talking to the control-plane node with the appropriate credentials, run:

```bash
kubectl drain <node name> --delete-emptydir-data --force --ignore-daemonsets
```
Before removing the node, reset the state installed by kubeadm:

kubeadm reset

The reset process does not reset or clean up iptables rules or IPVS tables. If you wish to reset iptables, you must do so manually:

iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

If you want to reset the IPVS tables, you must run the following command:

ipvsadm -C

Now remove the node:

kubectl delete node <node name>

If you wish to start over, run kubeadm init or kubeadm join with the appropriate arguments.
Clean up the control plane

You can use kubeadm reset on the control plane host to trigger a best-effort clean up.

See the kubeadm reset reference documentation for more information about this subcommand and its options.
What's next
Verify that your cluster is running properly with Sonobuoy
See Upgrading kubeadm clusters for details about upgrading your cluster using kubeadm.
Learn about advanced kubeadm usage in the kubeadm reference documentation
Learn more about Kubernetes concepts and kubectl.