This is a sysadmin package for deploying a cluster with kubernetes and `DOCKER`

DOCKER specifically is the ONLY container run time that will work with this software as its the entire intent of the codebase
I want to make an entry level kubernetes primer for myself and others to learn from


I made this so I can learn devSECops AFTER learning devops

The vast majority of this module/package is hacked together python/bash (maybe a bit of go as well)
from online resources such as medium.com and stackexchange, and countless tutorials

    admin username: meep_admin
    cluster name  : meeplabben

# Intent

    To establish a cluster, production ready, hardened on all possible services, with an aim towards automated node deployment
    
    for the purposes of training hackers



When creating a cluster with `kind` a CA cert is generated automatically, *BUT* you can use `init_ca.sh` to begin establishing your certificate authority on your own

However, some steps must be performed manually to prevent unauthorized modifications
To get CA cert from cluster, find control plane node name in docker and use this command 

    #this doesnt  work, why doesnt this  work, the image is there and running
    docker cp f5aa68ba122a:/etc/kubernetes/pki/ca.key ./ca.key

# Basic Information About Kubernetes

> ## `Pod`
  
    It's an abstraction in Kubernetes made of a set of application containers (or just one) and their shared resources (shared storage, information about how each container should be run, networking, etc.). 
  
    Once you set up a deployment, it will automatically create pods, incorporating multiple containers. Each pod is connected to the Node. Once that Node fails, your identical PODs will get scheduled on other variable Nodes included in your Kubernetes cluster.

> ## `Service`

        It's an abstraction that describes your Kubernetes cluster. 

    Its role is to make your application available to the networks that your cluster's connected to. In short, it exposes it to the outside world...

    Your application service gets a network request. Then, it makes an inventory of all those Pods in your Kubernetes cluster that match the service's selector, picks one and forwards it to the network requesting it. 

> ## FLOW OF OPERATION

  * prepare system
  * install tooling
  * write configs and deployment yaml files
  * initialize cluster
  * establish network configurations
  * switch context
  * load images
  * establish network configurations

# creation of cluster

## > `pull images for kube-system`
    
    kubeadm config images pull

## create with kubeadm for docker

The command to create a cluster with kubeadm/kubectl 

>`--cri-socket=unix:///var/run/cri-dockerd.sock` is the flag/value for using docker with kubernetes, without kind
```bash
sudo kubeadm init --cri-socket=unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16
```

> ## `To print a join command for a new worker node use:`

> `kubeadm token create --print-join-command`

But if you need to join a new control plane node, you need to recreate a new key for the control plane join command.
    
* Re upload certificates in the already working master node
    
> `kubeadm init phase upload-certs --upload-certs`

That will generate a new certificate key.

* Print join command in the already working master node 

> `kubeadm token create --print-join-command`
    
    moop@devbox:~$ kubeadm token create --print-join-command
    kubeadm join 192.168.47.128:6443 --token chlg9g.t4ea6slmm9yr0b7g --discovery-token-ca-cert-hash sha256:8a8009114acabd0d5ea4c04c6cbe79e32eedeb6675ecec172fe3a46085812f33 


* Join a new control plane node

> `$JOIN_COMMAND_FROM_STEP2 --control-plane --certificate-key $KEY_FROM_STEP1`

This might not work for the old Kubernetes versions but I tried with the new version and it worked for me.

# establish pod network with addon (necessary)
For the purposes of this tutorial, we awill be using `flannel`
> For flannel to work correctly, `--pod-network-cidr=10.244.0.0/16` has to be passed to kubeadm init.

```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## create with kind
> ### `see load nginx pod below for yaml`
>`moop@devbox:~/Desktop/sysadmin_package$ ./bin/kind create cluster --name meeplabben --config ./lib/yaml_repo/nginx_cluster.yml`
    
    Creating cluster "meeplabben" ...
    ✓ Ensuring node image (kindest/node:v1.24.0) 🖼
    ✓ Preparing nodes 📦  
    ✓ Writing configuration 📜 
    ✓ Starting control-plane 🕹️ 
    ✓ Installing CNI 🔌 
    ✓ Installing StorageClass 💾 
    Set kubectl context to "kind-meeplabben"
    You can now use your cluster with:

    Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂

## set context with kubectl
    
kind prepends "kind" to the name
>`moop@devbox:~/Desktop/sysadmin_package$ kubectl cluster-info --context kind-meeplabben`

    Kubernetes control plane is running at https://127.0.0.1:39233
    CoreDNS is running at https://127.0.0.1:39233/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

 	

# building and deploying docker containers in the kind cluster

## Loading an Image Into Your Cluster

Docker images can be loaded into your cluster nodes with:

    kind load docker-image my-custom-image-0 my-custom-image-1

>`Note: If using a named cluster you will need to specify the name of the cluster you wish to load the images into: kind load docker-image my-custom-image-0 my-custom-image-1 --name kind-2`

     
Additionally, image archives can be loaded with: 
    
    kind load image-archive /my-image-archive.tar

This allows a workflow like:

```bash
docker build -t my-custom-image:unique-tag ./my-image-dir
kind load docker-image my-custom-image:unique-tag
kubectl apply -f my-manifest-using-my-image:unique-tag
```


Warning: Kubeadm signs the certificate in the `admin.conf` to have `Subject: O = system:masters, CN = kubernetes-admin`. 

`system:masters` is a break-glass, super user group that bypasses the authorization layer (e.g. RBAC). 

>DO NOT share the `admin.conf` file with anyone and instead grant users custom permissions by generating them a kubeconfig file using the kubeadm kubeconfig user command. For more details see Generating kubeconfig files for additional users.