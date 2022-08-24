Initializing your control-plane node

The control-plane node is the machine where the control plane components run, including etcd (the cluster database) and the API Server (which the kubectl command line tool communicates with).

* >`Recommended` 
    
    If you have plans to upgrade this single control-plane kubeadm cluster to high availability you should specify the --control-plane-endpoint to set the shared endpoint for all control-plane nodes. Such an endpoint can be either a DNS name or an IP address of a load-balancer.

Choose a Pod network add-on, and verify whether it requires any arguments to be passed to kubeadm init. Depending on which third-party provider you choose, you might need to set the --pod-network-cidr to a provider-specific value. See Installing a Pod network add-on.

* > `Optional`
    
    kubeadm tries to detect the container runtime by using a list of well known endpoints. To use different container runtime or if there are more than one installed on the provisioned node, specify the --cri-socket argument to kubeadm. See Installing a runtime.
    
* > `Optional` 

    Unless otherwise specified, kubeadm uses the network interface associated with the default gateway to set the advertise address for this particular control-plane node's API server. To use a different network interface, specify the --apiserver-advertise-address=<ip-address> argument to kubeadm init. To deploy an IPv6 Kubernetes cluster using IPv6 addressing, you must specify an IPv6 address, for example --apiserver-advertise-address=fd00::101



>`--apiserver-advertise-address string`

    The IP address the API Server will advertise it's listening on. If not set the default network interface will be used.

>`--apiserver-bind-port int32     Default: 6443`

    Port for the API Server to bind to.

> ## `pull images for kube-system`

```bash
kubeadm config images pull
```

    moop@devbox:~$ kubeadm config images pull
    [config/images] Pulled k8s.gcr.io/kube-apiserver:v1.24.3
    [config/images] Pulled k8s.gcr.io/kube-controller-manager:v1.24.3
    [config/images] Pulled k8s.gcr.io/kube-scheduler:v1.24.3
    [config/images] Pulled k8s.gcr.io/kube-proxy:v1.24.3
    [config/images] Pulled k8s.gcr.io/pause:3.7
    [config/images] Pulled k8s.gcr.io/etcd:3.5.3-0
    [config/images] Pulled k8s.gcr.io/coredns/coredns:v1.8.6

## create with kubeadm for docker

The command to create a cluster with kubeadm/kubectl 

>`--cri-socket=unix:///var/run/cri-dockerd.sock` is the flag/value for using docker with kubernetes, without kind
```bash
sudo kubeadm init --cri-socket=unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16
```

# (Required) Install a networking layer
### We are using flannel for this tutorial so please follow the instructions in applying a flannel layer
> Use the tutorial for flannel in `flannel_implementation.md`

install flannel using the yml template that's provided by CoreOS and their repositories on GitHub. This template is also going to create several different objects allowing Flannel to run successfully. And we are going to be doing this on our master node which is an important step. Make sure that you don't accidentally try to install it on one of your cluster nodes. Remember to run it just on the Kubernetes master

>For the purposes of this tutorial, the master is the only computer in use, and the nodes are all virtualized

```bash
# initialize the nodes implementing flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
# apply roles and bindings for access to nodes
https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
```

> For flannel to work correctly, `--pod-network-cidr=10.244.0.0/16` has to be passed to kubeadm init.

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
```
> ## Verify core-DNS / flannel is working

    kubectl -n kube-system -l=k8s-app=kube-dns get pods

> ### `results of kubeadm init`
    moop@devbox:~$ sudo kubeadm init --cri-socket=unix:///var/run/cri-dockerd.sock

    --- SNIP ---

    Your Kubernetes control-plane has initialized successfully!

    To start using your cluster, you need to run the following as a regular user:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    Alternatively, if you are the root user, you can run:

    export KUBECONFIG=/etc/kubernetes/admin.conf

    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/

    Then you can join any number of worker nodes by running the following on each as root:

    kubeadm join 192.168.47.128:6443 --token wy2niv.gu6m6zve7aqovcbb \
        --discovery-token-ca-cert-hash sha256:89a7b7c9594085c8d4fe5bf3016bb353a4ce3b9293e0c02bb1dfd031587bf9ac 

The bottom part is a necessary step

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Followed by this
    
    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/

    Then you can join any number of worker nodes by running the following on each as root:

    kubeadm join 192.168.47.128:6443 --token wy2niv.gu6m6zve7aqovcbb \
        --discovery-token-ca-cert-hash sha256:89a7b7c9594085c8d4fe5bf3016bb353a4ce3b9293e0c02bb1dfd031587bf9ac 

># `Running Workloads on the Master Node: Control plane node isolation`

By default, no workloads will run on the master node, and will not schedule Pods on the control plane nodes for security reasons.
You usually want this in a production environment. 
In my case, since I'm using it for development and testing, I want to allow containers to run on the master node as well. 
This is done by a process called "tainting/untainting" the host.

> On the master, we can run the command `kubectl taint nodes --all node-role.kubernetes.io/master-` and allow the master to run workloads as well.
> we also have to run `kubectl taint nodes --all node-role.kubernetes.io/control-plane-`
> ## to remove a taint you must add a hyphen on the end!!!

# After creating the cluster with kubeadm

The network must be deployed before any applications. 
Also, CoreDNS will not start up before a network is installed. 
kubeadm only supports Container Network Interface (CNI) based networks (and does not support kubenet).

Once you do this, the CoreDNS pods should come up healthy. 
This can be verified with: 

```bash
kubectl -n kube-system -l=k8s-app=kube-dns get pods
```
PLEASE FOLLOW THE INSTRUCTIONS IN `NETWORKING_WITH_FLANNEL.MD`
(run kubectl apply -f ./flannel_networking.yml)

> `kubectl taint nodes --all node-role.kubernetes.io/control-plane- node-role.kubernetes.io/master-`




> ## creating necessary name spaces

    kubectl create ns ingress-nginx 
