Name:                 kube-flannel-ds-ztwt8
Namespace:            kube-flannel
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 10:25:59 -0400
Labels:               app=flannel
                      controller-revision-hash=5d454f6775
                      pod-template-generation=1
                      tier=node
Annotations:          <none>
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  DaemonSet/kube-flannel-ds
Init Containers:
  install-cni-plugin:
    Container ID:  docker://b14dda1dced0f106de8e098df2ba89cbf0f1a81cf7c30addd9ceb2d4599f5b5c
    Image:         docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0
    Image ID:      docker-pullable://rancher/mirrored-flannelcni-flannel-cni-plugin@sha256:28d3a6be9f450282bf42e4dad143d41da23e3d91f66f19c01ee7fd21fd17cb2b
    Port:          <none>
    Host Port:     <none>
    Command:
      cp
    Args:
      -f
      /flannel
      /opt/cni/bin/flannel
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Mon, 15 Aug 2022 10:26:04 -0400
      Finished:     Mon, 15 Aug 2022 10:26:04 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /opt/cni/bin from cni-plugin (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qf7vx (ro)
  install-cni:
    Container ID:  docker://75c7a77c4822342e208f169d8d77529ca324d27db8c6a56c2ccd9b8ad4f3608e
    Image:         docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1
    Image ID:      docker-pullable://rancher/mirrored-flannelcni-flannel@sha256:e3b0f06121b0f7a11a684e910bba89b3ab49cd6e73aeb6c719f83b2456946366
    Port:          <none>
    Host Port:     <none>
    Command:
      cp
    Args:
      -f
      /etc/kube-flannel/cni-conf.json
      /etc/cni/net.d/10-flannel.conflist
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Mon, 15 Aug 2022 10:26:19 -0400
      Finished:     Mon, 15 Aug 2022 10:26:19 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /etc/cni/net.d from cni (rw)
      /etc/kube-flannel/ from flannel-cfg (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qf7vx (ro)
Containers:
  kube-flannel:
    Container ID:  docker://a0ff67149dafa97f7c56791e10402d7f28a69bb8b1cbec39e276f14323165e98
    Image:         docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1
    Image ID:      docker-pullable://rancher/mirrored-flannelcni-flannel@sha256:e3b0f06121b0f7a11a684e910bba89b3ab49cd6e73aeb6c719f83b2456946366
    Port:          <none>
    Host Port:     <none>
    Command:
      /opt/bin/flanneld
    Args:
      --ip-masq
      --kube-subnet-mgr
    State:          Running
      Started:      Mon, 15 Aug 2022 10:26:20 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     100m
      memory:  50Mi
    Requests:
      cpu:     100m
      memory:  50Mi
    Environment:
      POD_NAME:           kube-flannel-ds-ztwt8 (v1:metadata.name)
      POD_NAMESPACE:      kube-flannel (v1:metadata.namespace)
      EVENT_QUEUE_DEPTH:  5000
    Mounts:
      /etc/kube-flannel/ from flannel-cfg (rw)
      /run/flannel from run (rw)
      /run/xtables.lock from xtables-lock (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qf7vx (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  run:
    Type:          HostPath (bare host directory volume)
    Path:          /run/flannel
    HostPathType:  
  cni-plugin:
    Type:          HostPath (bare host directory volume)
    Path:          /opt/cni/bin
    HostPathType:  
  cni:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/cni/net.d
    HostPathType:  
  flannel-cfg:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-flannel-cfg
    Optional:  false
  xtables-lock:
    Type:          HostPath (bare host directory volume)
    Path:          /run/xtables.lock
    HostPathType:  FileOrCreate
  kube-api-access-qf7vx:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 :NoSchedule op=Exists
                             node.kubernetes.io/disk-pressure:NoSchedule op=Exists
                             node.kubernetes.io/memory-pressure:NoSchedule op=Exists
                             node.kubernetes.io/network-unavailable:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists
                             node.kubernetes.io/pid-pressure:NoSchedule op=Exists
                             node.kubernetes.io/unreachable:NoExecute op=Exists
                             node.kubernetes.io/unschedulable:NoSchedule op=Exists
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  31m   default-scheduler  Successfully assigned kube-flannel/kube-flannel-ds-ztwt8 to devbox
  Normal  Pulling    31m   kubelet            Pulling image "docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0"
  Normal  Pulled     31m   kubelet            Successfully pulled image "docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0" in 3.023103336s
  Normal  Created    31m   kubelet            Created container install-cni-plugin
  Normal  Started    31m   kubelet            Started container install-cni-plugin
  Normal  Pulling    31m   kubelet            Pulling image "docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1"
  Normal  Pulled     31m   kubelet            Successfully pulled image "docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1" in 7.599228364s
  Normal  Created    30m   kubelet            Created container install-cni
  Normal  Started    30m   kubelet            Started container install-cni
  Normal  Pulled     30m   kubelet            Container image "docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1" already present on machine
  Normal  Created    30m   kubelet            Created container kube-flannel
  Normal  Started    30m   kubelet            Started container kube-flannel


Name:                 coredns-6d4b75cb6d-lmssz
Namespace:            kube-system
Priority:             2000000000
Priority Class Name:  system-cluster-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:14 -0400
Labels:               k8s-app=kube-dns
                      pod-template-hash=6d4b75cb6d
Annotations:          <none>
Status:               Running
IP:                   10.244.0.3
IPs:
  IP:           10.244.0.3
Controlled By:  ReplicaSet/coredns-6d4b75cb6d
Containers:
  coredns:
    Container ID:  docker://4121f2a2c786348c40abb7111bef0e06a53470fbf2e63427ce35a5238c60e5bf
    Image:         k8s.gcr.io/coredns/coredns:v1.8.6
    Image ID:      docker-pullable://k8s.gcr.io/coredns/coredns@sha256:5b6ec0d6de9baaf3e92d0f66cd96a25b9edbce8716f5f15dcd1a616b3abd590e
    Ports:         53/UDP, 53/TCP, 9153/TCP
    Host Ports:    0/UDP, 0/TCP, 0/TCP
    Args:
      -conf
      /etc/coredns/Corefile
    State:          Running
      Started:      Mon, 15 Aug 2022 09:53:16 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-8jmpt (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      coredns
    Optional:  false
  kube-api-access-8jmpt:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 CriticalAddonsOnly op=Exists
                             node-role.kubernetes.io/control-plane:NoSchedule
                             node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>


Name:                 coredns-6d4b75cb6d-vsr9b
Namespace:            kube-system
Priority:             2000000000
Priority Class Name:  system-cluster-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:14 -0400
Labels:               k8s-app=kube-dns
                      pod-template-hash=6d4b75cb6d
Annotations:          <none>
Status:               Running
IP:                   10.244.0.2
IPs:
  IP:           10.244.0.2
Controlled By:  ReplicaSet/coredns-6d4b75cb6d
Containers:
  coredns:
    Container ID:  docker://796b5c8444f8c5f5f87375bcf70365befcf30e48ac7fd65250d3027d6a7a8d67
    Image:         k8s.gcr.io/coredns/coredns:v1.8.6
    Image ID:      docker-pullable://k8s.gcr.io/coredns/coredns@sha256:5b6ec0d6de9baaf3e92d0f66cd96a25b9edbce8716f5f15dcd1a616b3abd590e
    Ports:         53/UDP, 53/TCP, 9153/TCP
    Host Ports:    0/UDP, 0/TCP, 0/TCP
    Args:
      -conf
      /etc/coredns/Corefile
    State:          Running
      Started:      Mon, 15 Aug 2022 09:53:16 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-8tzkg (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      coredns
    Optional:  false
  kube-api-access-8tzkg:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 CriticalAddonsOnly op=Exists
                             node-role.kubernetes.io/control-plane:NoSchedule
                             node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>


Name:                 etcd-devbox
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:01 -0400
Labels:               component=etcd
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://192.168.47.128:2379
                      kubernetes.io/config.hash: d5bcd9d4c3d862ade056fb90d4e74657
                      kubernetes.io/config.mirror: d5bcd9d4c3d862ade056fb90d4e74657
                      kubernetes.io/config.seen: 2022-08-15T09:53:00.607407410-04:00
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  Node/devbox
Containers:
  etcd:
    Container ID:  docker://768f8c04d082add3cb3f574b3837dd00094ac4d93a9f51d18f7346101f7a140f
    Image:         k8s.gcr.io/etcd:3.5.3-0
    Image ID:      docker-pullable://k8s.gcr.io/etcd@sha256:13f53ed1d91e2e11aac476ee9a0269fdda6cc4874eba903efd40daf50c55eee5
    Port:          <none>
    Host Port:     <none>
    Command:
      etcd
      --advertise-client-urls=https://192.168.47.128:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --experimental-initial-corrupt-check=true
      --initial-advertise-peer-urls=https://192.168.47.128:2380
      --initial-cluster=devbox=https://192.168.47.128:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://192.168.47.128:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://192.168.47.128:2380
      --name=devbox
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    State:          Running
      Started:      Mon, 15 Aug 2022 09:52:53 -0400
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Liveness:     http-get http://127.0.0.1:2381/health delay=10s timeout=15s period=10s #success=1 #failure=8
    Startup:      http-get http://127.0.0.1:2381/health delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
      /var/lib/etcd from etcd-data (rw)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  etcd-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki/etcd
    HostPathType:  DirectoryOrCreate
  etcd-data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/etcd
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:            <none>


Name:                 kube-apiserver-devbox
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:01 -0400
Labels:               component=kube-apiserver
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.47.128:6443
                      kubernetes.io/config.hash: 27dad3d3641d1611fb1c5269389cc079
                      kubernetes.io/config.mirror: 27dad3d3641d1611fb1c5269389cc079
                      kubernetes.io/config.seen: 2022-08-15T09:53:00.607411187-04:00
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  Node/devbox
Containers:
  kube-apiserver:
    Container ID:  docker://00f12b7410db3bc3d1deb502ca987b5ec2cb7ce0b61fd6f8f472cded43f369be
    Image:         k8s.gcr.io/kube-apiserver:v1.24.3
    Image ID:      docker-pullable://k8s.gcr.io/kube-apiserver@sha256:a04609b85962da7e6531d32b75f652b4fb9f5fe0b0ee0aa160856faad8ec5d96
    Port:          <none>
    Host Port:     <none>
    Command:
      kube-apiserver
      --advertise-address=192.168.47.128
      --allow-privileged=true
      --authorization-mode=Node,RBAC
      --client-ca-file=/etc/kubernetes/pki/ca.crt
      --enable-admission-plugins=NodeRestriction
      --enable-bootstrap-token-auth=true
      --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
      --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
      --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
      --etcd-servers=https://127.0.0.1:2379
      --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
      --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
      --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
      --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
      --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
      --requestheader-allowed-names=front-proxy-client
      --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
      --requestheader-extra-headers-prefix=X-Remote-Extra-
      --requestheader-group-headers=X-Remote-Group
      --requestheader-username-headers=X-Remote-User
      --secure-port=6443
      --service-account-issuer=https://kubernetes.default.svc.cluster.local
      --service-account-key-file=/etc/kubernetes/pki/sa.pub
      --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
      --service-cluster-ip-range=10.96.0.0/12
      --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
      --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    State:          Running
      Started:      Mon, 15 Aug 2022 09:52:53 -0400
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        250m
    Liveness:     http-get https://192.168.47.128:6443/livez delay=10s timeout=15s period=10s #success=1 #failure=8
    Readiness:    http-get https://192.168.47.128:6443/readyz delay=0s timeout=15s period=1s #success=1 #failure=3
    Startup:      http-get https://192.168.47.128:6443/livez delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/ca-certificates from etc-ca-certificates (ro)
      /etc/kubernetes/pki from k8s-certs (ro)
      /etc/pki from etc-pki (ro)
      /etc/ssl/certs from ca-certs (ro)
      /usr/local/share/ca-certificates from usr-local-share-ca-certificates (ro)
      /usr/share/ca-certificates from usr-share-ca-certificates (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  ca-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ssl/certs
    HostPathType:  DirectoryOrCreate
  etc-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ca-certificates
    HostPathType:  DirectoryOrCreate
  etc-pki:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/pki
    HostPathType:  DirectoryOrCreate
  k8s-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki
    HostPathType:  DirectoryOrCreate
  usr-local-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/local/share/ca-certificates
    HostPathType:  DirectoryOrCreate
  usr-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/share/ca-certificates
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:            <none>


Name:                 kube-controller-manager-devbox
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:01 -0400
Labels:               component=kube-controller-manager
                      tier=control-plane
Annotations:          kubernetes.io/config.hash: 2cbb6d87e2ea3b1e8a29c43d7a918610
                      kubernetes.io/config.mirror: 2cbb6d87e2ea3b1e8a29c43d7a918610
                      kubernetes.io/config.seen: 2022-08-15T09:53:00.607413150-04:00
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  Node/devbox
Containers:
  kube-controller-manager:
    Container ID:  docker://bd44f8f636a41f605eb5b18d13241e2d49f048a37d8ed915a21f39f481b203b5
    Image:         k8s.gcr.io/kube-controller-manager:v1.24.3
    Image ID:      docker-pullable://k8s.gcr.io/kube-controller-manager@sha256:f504eead8b8674ebc9067370ef51abbdc531b4a81813bfe464abccb8c76b6a53
    Port:          <none>
    Host Port:     <none>
    Command:
      kube-controller-manager
      --allocate-node-cidrs=true
      --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
      --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
      --bind-address=127.0.0.1
      --client-ca-file=/etc/kubernetes/pki/ca.crt
      --cluster-cidr=10.244.0.0/16
      --cluster-name=kubernetes
      --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
      --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
      --controllers=*,bootstrapsigner,tokencleaner
      --kubeconfig=/etc/kubernetes/controller-manager.conf
      --leader-elect=true
      --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
      --root-ca-file=/etc/kubernetes/pki/ca.crt
      --service-account-private-key-file=/etc/kubernetes/pki/sa.key
      --service-cluster-ip-range=10.96.0.0/12
      --use-service-account-credentials=true
    State:          Running
      Started:      Mon, 15 Aug 2022 09:52:53 -0400
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        200m
    Liveness:     http-get https://127.0.0.1:10257/healthz delay=10s timeout=15s period=10s #success=1 #failure=8
    Startup:      http-get https://127.0.0.1:10257/healthz delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/ca-certificates from etc-ca-certificates (ro)
      /etc/kubernetes/controller-manager.conf from kubeconfig (ro)
      /etc/kubernetes/pki from k8s-certs (ro)
      /etc/pki from etc-pki (ro)
      /etc/ssl/certs from ca-certs (ro)
      /usr/libexec/kubernetes/kubelet-plugins/volume/exec from flexvolume-dir (rw)
      /usr/local/share/ca-certificates from usr-local-share-ca-certificates (ro)
      /usr/share/ca-certificates from usr-share-ca-certificates (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  ca-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ssl/certs
    HostPathType:  DirectoryOrCreate
  etc-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ca-certificates
    HostPathType:  DirectoryOrCreate
  etc-pki:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/pki
    HostPathType:  DirectoryOrCreate
  flexvolume-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/libexec/kubernetes/kubelet-plugins/volume/exec
    HostPathType:  DirectoryOrCreate
  k8s-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki
    HostPathType:  DirectoryOrCreate
  kubeconfig:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/controller-manager.conf
    HostPathType:  FileOrCreate
  usr-local-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/local/share/ca-certificates
    HostPathType:  DirectoryOrCreate
  usr-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/share/ca-certificates
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:            <none>


Name:                 kube-proxy-8bffn
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:14 -0400
Labels:               controller-revision-hash=94985b49
                      k8s-app=kube-proxy
                      pod-template-generation=1
Annotations:          <none>
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  DaemonSet/kube-proxy
Containers:
  kube-proxy:
    Container ID:  docker://e8671a9c19c37fb12202814f8588b6560a30edb23c993c2011ab34e5b4988722
    Image:         k8s.gcr.io/kube-proxy:v1.24.3
    Image ID:      docker-pullable://k8s.gcr.io/kube-proxy@sha256:c1b135231b5b1a6799346cd701da4b59e5b7ef8e694ec7b04fb23b8dbe144137
    Port:          <none>
    Host Port:     <none>
    Command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)
    State:          Running
      Started:      Mon, 15 Aug 2022 09:53:15 -0400
    Ready:          True
    Restart Count:  0
    Environment:
      NODE_NAME:   (v1:spec.nodeName)
    Mounts:
      /lib/modules from lib-modules (ro)
      /run/xtables.lock from xtables-lock (rw)
      /var/lib/kube-proxy from kube-proxy (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-7j6kh (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-proxy:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-proxy
    Optional:  false
  xtables-lock:
    Type:          HostPath (bare host directory volume)
    Path:          /run/xtables.lock
    HostPathType:  FileOrCreate
  lib-modules:
    Type:          HostPath (bare host directory volume)
    Path:          /lib/modules
    HostPathType:  
  kube-api-access-7j6kh:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 op=Exists
                             node.kubernetes.io/disk-pressure:NoSchedule op=Exists
                             node.kubernetes.io/memory-pressure:NoSchedule op=Exists
                             node.kubernetes.io/network-unavailable:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists
                             node.kubernetes.io/pid-pressure:NoSchedule op=Exists
                             node.kubernetes.io/unreachable:NoExecute op=Exists
                             node.kubernetes.io/unschedulable:NoSchedule op=Exists
Events:                      <none>


Name:                 kube-scheduler-devbox
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 devbox/192.168.47.128
Start Time:           Mon, 15 Aug 2022 09:53:01 -0400
Labels:               component=kube-scheduler
                      tier=control-plane
Annotations:          kubernetes.io/config.hash: 0911cc44eefd52951cbc9024f8a61f17
                      kubernetes.io/config.mirror: 0911cc44eefd52951cbc9024f8a61f17
                      kubernetes.io/config.seen: 2022-08-15T09:53:00.607414863-04:00
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   192.168.47.128
IPs:
  IP:           192.168.47.128
Controlled By:  Node/devbox
Containers:
  kube-scheduler:
    Container ID:  docker://07beeaeff11b7439b9cb27ec067e1dfbc921adbd294cb4c9d9cd877f0d0455e8
    Image:         k8s.gcr.io/kube-scheduler:v1.24.3
    Image ID:      docker-pullable://k8s.gcr.io/kube-scheduler@sha256:e199523298224cd9f2a9a43c7c2c37fa57aff87648ed1e1de9984eba6f6005f0
    Port:          <none>
    Host Port:     <none>
    Command:
      kube-scheduler
      --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
      --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
      --bind-address=127.0.0.1
      --kubeconfig=/etc/kubernetes/scheduler.conf
      --leader-elect=true
    State:          Running
      Started:      Mon, 15 Aug 2022 09:52:53 -0400
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
    Liveness:     http-get https://127.0.0.1:10259/healthz delay=10s timeout=15s period=10s #success=1 #failure=8
    Startup:      http-get https://127.0.0.1:10259/healthz delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/kubernetes/scheduler.conf from kubeconfig (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kubeconfig:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/scheduler.conf
    HostPathType:  FileOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:            <none>


Name:           dashboard-metrics-scraper-8c47d4b5d-tl9k8
Namespace:      kubernetes-dashboard
Priority:       0
Node:           <none>
Labels:         k8s-app=dashboard-metrics-scraper
                pod-template-hash=8c47d4b5d
Annotations:    seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/dashboard-metrics-scraper-8c47d4b5d
Containers:
  dashboard-metrics-scraper:
    Image:        kubernetesui/metrics-scraper:v1.0.8
    Port:         8000/TCP
    Host Port:    0/TCP
    Liveness:     http-get http://:8000/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /tmp from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dsq9j (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-dsq9j:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age                  From               Message
  ----     ------            ----                 ----               -------
  Warning  FailedScheduling  4m15s (x6 over 29m)  default-scheduler  0/1 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.


Name:           kubernetes-dashboard-5676d8b865-n4zwv
Namespace:      kubernetes-dashboard
Priority:       0
Node:           <none>
Labels:         k8s-app=kubernetes-dashboard
                pod-template-hash=5676d8b865
Annotations:    seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/kubernetes-dashboard-5676d8b865
Containers:
  kubernetes-dashboard:
    Image:      kubernetesui/dashboard:v2.6.0
    Port:       8443/TCP
    Host Port:  0/TCP
    Args:
      --auto-generate-certificates
      --namespace=kubernetes-dashboard
    Liveness:     http-get https://:8443/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /certs from kubernetes-dashboard-certs (rw)
      /tmp from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hstc7 (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  kubernetes-dashboard-certs:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  kubernetes-dashboard-certs
    Optional:    false
  tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-hstc7:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age                  From               Message
  ----     ------            ----                 ----               -------
  Warning  FailedScheduling  4m15s (x6 over 29m)  default-scheduler  0/1 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.


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


Name:              kube-dns
Namespace:         kube-system
Labels:            k8s-app=kube-dns
                   kubernetes.io/cluster-service=true
                   kubernetes.io/name=CoreDNS
Annotations:       prometheus.io/port: 9153
                   prometheus.io/scrape: true
Selector:          k8s-app=kube-dns
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.0.10
IPs:               10.96.0.10
Port:              dns  53/UDP
TargetPort:        53/UDP
Endpoints:         10.244.0.2:53,10.244.0.3:53
Port:              dns-tcp  53/TCP
TargetPort:        53/TCP
Endpoints:         10.244.0.2:53,10.244.0.3:53
Port:              metrics  9153/TCP
TargetPort:        9153/TCP
Endpoints:         10.244.0.2:9153,10.244.0.3:9153
Session Affinity:  None
Events:            <none>


Name:              dashboard-metrics-scraper
Namespace:         kubernetes-dashboard
Labels:            k8s-app=dashboard-metrics-scraper
Annotations:       <none>
Selector:          k8s-app=dashboard-metrics-scraper
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.100.20.166
IPs:               10.100.20.166
Port:              <unset>  8000/TCP
TargetPort:        8000/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>


Name:              kubernetes-dashboard
Namespace:         kubernetes-dashboard
Labels:            k8s-app=kubernetes-dashboard
Annotations:       <none>
Selector:          k8s-app=kubernetes-dashboard
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.111.179.148
IPs:               10.111.179.148
Port:              <unset>  443/TCP
TargetPort:        8443/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>


Name:           kube-flannel-ds
Selector:       app=flannel
Node-Selector:  <none>
Labels:         app=flannel
                tier=node
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=flannel
                    tier=node
  Service Account:  flannel
  Init Containers:
   install-cni-plugin:
    Image:      docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
      -f
      /flannel
      /opt/cni/bin/flannel
    Environment:  <none>
    Mounts:
      /opt/cni/bin from cni-plugin (rw)
   install-cni:
    Image:      docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
      -f
      /etc/kube-flannel/cni-conf.json
      /etc/cni/net.d/10-flannel.conflist
    Environment:  <none>
    Mounts:
      /etc/cni/net.d from cni (rw)
      /etc/kube-flannel/ from flannel-cfg (rw)
  Containers:
   kube-flannel:
    Image:      docker.io/rancher/mirrored-flannelcni-flannel:v0.19.1
    Port:       <none>
    Host Port:  <none>
    Command:
      /opt/bin/flanneld
    Args:
      --ip-masq
      --kube-subnet-mgr
    Limits:
      cpu:     100m
      memory:  50Mi
    Requests:
      cpu:     100m
      memory:  50Mi
    Environment:
      POD_NAME:            (v1:metadata.name)
      POD_NAMESPACE:       (v1:metadata.namespace)
      EVENT_QUEUE_DEPTH:  5000
    Mounts:
      /etc/kube-flannel/ from flannel-cfg (rw)
      /run/flannel from run (rw)
      /run/xtables.lock from xtables-lock (rw)
  Volumes:
   run:
    Type:          HostPath (bare host directory volume)
    Path:          /run/flannel
    HostPathType:  
   cni-plugin:
    Type:          HostPath (bare host directory volume)
    Path:          /opt/cni/bin
    HostPathType:  
   cni:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/cni/net.d
    HostPathType:  
   flannel-cfg:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-flannel-cfg
    Optional:  false
   xtables-lock:
    Type:               HostPath (bare host directory volume)
    Path:               /run/xtables.lock
    HostPathType:       FileOrCreate
  Priority Class Name:  system-node-critical
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  31m   daemonset-controller  Created pod: kube-flannel-ds-ztwt8


Name:           kube-proxy
Selector:       k8s-app=kube-proxy
Node-Selector:  kubernetes.io/os=linux
Labels:         k8s-app=kube-proxy
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           k8s-app=kube-proxy
  Service Account:  kube-proxy
  Containers:
   kube-proxy:
    Image:      k8s.gcr.io/kube-proxy:v1.24.3
    Port:       <none>
    Host Port:  <none>
    Command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)
    Environment:
      NODE_NAME:   (v1:spec.nodeName)
    Mounts:
      /lib/modules from lib-modules (ro)
      /run/xtables.lock from xtables-lock (rw)
      /var/lib/kube-proxy from kube-proxy (rw)
  Volumes:
   kube-proxy:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-proxy
    Optional:  false
   xtables-lock:
    Type:          HostPath (bare host directory volume)
    Path:          /run/xtables.lock
    HostPathType:  FileOrCreate
   lib-modules:
    Type:               HostPath (bare host directory volume)
    Path:               /lib/modules
    HostPathType:       
  Priority Class Name:  system-node-critical
Events:                 <none>


Name:                   coredns
Namespace:              kube-system
CreationTimestamp:      Mon, 15 Aug 2022 09:53:00 -0400
Labels:                 k8s-app=kube-dns
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               k8s-app=kube-dns
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 25% max surge
Pod Template:
  Labels:           k8s-app=kube-dns
  Service Account:  coredns
  Containers:
   coredns:
    Image:       k8s.gcr.io/coredns/coredns:v1.8.6
    Ports:       53/UDP, 53/TCP, 9153/TCP
    Host Ports:  0/UDP, 0/TCP, 0/TCP
    Args:
      -conf
      /etc/coredns/Corefile
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
  Volumes:
   config-volume:
    Type:               ConfigMap (a volume populated by a ConfigMap)
    Name:               coredns
    Optional:           false
  Priority Class Name:  system-cluster-critical
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   coredns-6d4b75cb6d (2/2 replicas created)
Events:          <none>


Name:                   dashboard-metrics-scraper
Namespace:              kubernetes-dashboard
CreationTimestamp:      Mon, 15 Aug 2022 10:27:53 -0400
Labels:                 k8s-app=dashboard-metrics-scraper
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               k8s-app=dashboard-metrics-scraper
Replicas:               1 desired | 1 updated | 1 total | 0 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           k8s-app=dashboard-metrics-scraper
  Service Account:  kubernetes-dashboard
  Containers:
   dashboard-metrics-scraper:
    Image:        kubernetesui/metrics-scraper:v1.0.8
    Port:         8000/TCP
    Host Port:    0/TCP
    Liveness:     http-get http://:8000/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /tmp from tmp-volume (rw)
  Volumes:
   tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    False   ProgressDeadlineExceeded
OldReplicaSets:  <none>
NewReplicaSet:   dashboard-metrics-scraper-8c47d4b5d (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  29m   deployment-controller  Scaled up replica set dashboard-metrics-scraper-8c47d4b5d to 1


Name:                   kubernetes-dashboard
Namespace:              kubernetes-dashboard
CreationTimestamp:      Mon, 15 Aug 2022 10:27:53 -0400
Labels:                 k8s-app=kubernetes-dashboard
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               k8s-app=kubernetes-dashboard
Replicas:               1 desired | 1 updated | 1 total | 0 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           k8s-app=kubernetes-dashboard
  Service Account:  kubernetes-dashboard
  Containers:
   kubernetes-dashboard:
    Image:      kubernetesui/dashboard:v2.6.0
    Port:       8443/TCP
    Host Port:  0/TCP
    Args:
      --auto-generate-certificates
      --namespace=kubernetes-dashboard
    Liveness:     http-get https://:8443/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /certs from kubernetes-dashboard-certs (rw)
      /tmp from tmp-volume (rw)
  Volumes:
   kubernetes-dashboard-certs:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  kubernetes-dashboard-certs
    Optional:    false
   tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    False   ProgressDeadlineExceeded
OldReplicaSets:  <none>
NewReplicaSet:   kubernetes-dashboard-5676d8b865 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  29m   deployment-controller  Scaled up replica set kubernetes-dashboard-5676d8b865 to 1


Name:           coredns-6d4b75cb6d
Namespace:      kube-system
Selector:       k8s-app=kube-dns,pod-template-hash=6d4b75cb6d
Labels:         k8s-app=kube-dns
                pod-template-hash=6d4b75cb6d
Annotations:    deployment.kubernetes.io/desired-replicas: 2
                deployment.kubernetes.io/max-replicas: 3
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/coredns
Replicas:       2 current / 2 desired
Pods Status:    2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           k8s-app=kube-dns
                    pod-template-hash=6d4b75cb6d
  Service Account:  coredns
  Containers:
   coredns:
    Image:       k8s.gcr.io/coredns/coredns:v1.8.6
    Ports:       53/UDP, 53/TCP, 9153/TCP
    Host Ports:  0/UDP, 0/TCP, 0/TCP
    Args:
      -conf
      /etc/coredns/Corefile
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
  Volumes:
   config-volume:
    Type:               ConfigMap (a volume populated by a ConfigMap)
    Name:               coredns
    Optional:           false
  Priority Class Name:  system-cluster-critical
Events:                 <none>


Name:           dashboard-metrics-scraper-8c47d4b5d
Namespace:      kubernetes-dashboard
Selector:       k8s-app=dashboard-metrics-scraper,pod-template-hash=8c47d4b5d
Labels:         k8s-app=dashboard-metrics-scraper
                pod-template-hash=8c47d4b5d
Annotations:    deployment.kubernetes.io/desired-replicas: 1
                deployment.kubernetes.io/max-replicas: 2
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/dashboard-metrics-scraper
Replicas:       1 current / 1 desired
Pods Status:    0 Running / 1 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           k8s-app=dashboard-metrics-scraper
                    pod-template-hash=8c47d4b5d
  Service Account:  kubernetes-dashboard
  Containers:
   dashboard-metrics-scraper:
    Image:        kubernetesui/metrics-scraper:v1.0.8
    Port:         8000/TCP
    Host Port:    0/TCP
    Liveness:     http-get http://:8000/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /tmp from tmp-volume (rw)
  Volumes:
   tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  29m   replicaset-controller  Created pod: dashboard-metrics-scraper-8c47d4b5d-tl9k8


Name:           kubernetes-dashboard-5676d8b865
Namespace:      kubernetes-dashboard
Selector:       k8s-app=kubernetes-dashboard,pod-template-hash=5676d8b865
Labels:         k8s-app=kubernetes-dashboard
                pod-template-hash=5676d8b865
Annotations:    deployment.kubernetes.io/desired-replicas: 1
                deployment.kubernetes.io/max-replicas: 2
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/kubernetes-dashboard
Replicas:       1 current / 1 desired
Pods Status:    0 Running / 1 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           k8s-app=kubernetes-dashboard
                    pod-template-hash=5676d8b865
  Service Account:  kubernetes-dashboard
  Containers:
   kubernetes-dashboard:
    Image:      kubernetesui/dashboard:v2.6.0
    Port:       8443/TCP
    Host Port:  0/TCP
    Args:
      --auto-generate-certificates
      --namespace=kubernetes-dashboard
    Liveness:     http-get https://:8443/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /certs from kubernetes-dashboard-certs (rw)
      /tmp from tmp-volume (rw)
  Volumes:
   kubernetes-dashboard-certs:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  kubernetes-dashboard-certs
    Optional:    false
   tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  29m   replicaset-controller  Created pod: kubernetes-dashboard-5676d8b865-n4zwv
