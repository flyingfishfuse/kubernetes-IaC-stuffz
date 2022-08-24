
[init] Using Kubernetes version: v1.24.3
[preflight] Running pre-flight checks
[preflight] Would pull the required images (like 'kubeadm config images pull')
[certs] Using certificateDir folder "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [devbox kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.47.128]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [devbox localhost] and IPs [192.168.47.128 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [devbox localhost] and IPs [192.168.47.128 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531/config.yaml"
[control-plane] Using manifest folder "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Would ensure that "/var/lib/etcd" directory is present
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531"
[dryrun] Wrote certificates, kubeconfig files and control plane manifests to the "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531" directory
[dryrun] The certificates or kubeconfig files would not be printed due to their sensitive nature
[dryrun] Please examine the "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531" directory for details about what would be written
[dryrun] Would write file "/etc/kubernetes/manifests/kube-apiserver.yaml" with content:
```yaml
	apiVersion: v1
	kind: Pod
	metadata:
	  annotations:
	    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.47.128:6443
	  creationTimestamp: null
	  labels:
	    component: kube-apiserver
	    tier: control-plane
	  name: kube-apiserver
	  namespace: kube-system
	spec:
	  containers:
	  - command:
	    - kube-apiserver
	    - --advertise-address=192.168.47.128
	    - --allow-privileged=true
	    - --authorization-mode=Node,RBAC
	    - --client-ca-file=/etc/kubernetes/pki/ca.crt
	    - --enable-admission-plugins=NodeRestriction
	    - --enable-bootstrap-token-auth=true
	    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
	    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
	    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
	    - --etcd-servers=https://127.0.0.1:2379
	    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
	    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
	    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
	    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
	    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
	    - --requestheader-allowed-names=front-proxy-client
	    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
	    - --requestheader-extra-headers-prefix=X-Remote-Extra-
	    - --requestheader-group-headers=X-Remote-Group
	    - --requestheader-username-headers=X-Remote-User
	    - --secure-port=6443
	    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
	    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
	    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
	    - --service-cluster-ip-range=10.96.0.0/12
	    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
	    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
	    image: k8s.gcr.io/kube-apiserver:v1.24.3
	    imagePullPolicy: IfNotPresent
	    livenessProbe:
	      failureThreshold: 8
	      httpGet:
	        host: 192.168.47.128
	        path: /livez
	        port: 6443
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    name: kube-apiserver
	    readinessProbe:
	      failureThreshold: 3
	      httpGet:
	        host: 192.168.47.128
	        path: /readyz
	        port: 6443
	        scheme: HTTPS
	      periodSeconds: 1
	      timeoutSeconds: 15
	    resources:
	      requests:
	        cpu: 250m
	    startupProbe:
	      failureThreshold: 24
	      httpGet:
	        host: 192.168.47.128
	        path: /livez
	        port: 6443
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    volumeMounts:
	    - mountPath: /etc/ssl/certs
	      name: ca-certs
	      readOnly: true
	    - mountPath: /etc/ca-certificates
	      name: etc-ca-certificates
	      readOnly: true
	    - mountPath: /etc/pki
	      name: etc-pki
	      readOnly: true
	    - mountPath: /etc/kubernetes/pki
	      name: k8s-certs
	      readOnly: true
	    - mountPath: /usr/local/share/ca-certificates
	      name: usr-local-share-ca-certificates
	      readOnly: true
	    - mountPath: /usr/share/ca-certificates
	      name: usr-share-ca-certificates
	      readOnly: true
	  hostNetwork: true
	  priorityClassName: system-node-critical
	  securityContext:
	    seccompProfile:
	      type: RuntimeDefault
	  volumes:
	  - hostPath:
	      path: /etc/ssl/certs
	      type: DirectoryOrCreate
	    name: ca-certs
	  - hostPath:
	      path: /etc/ca-certificates
	      type: DirectoryOrCreate
	    name: etc-ca-certificates
	  - hostPath:
	      path: /etc/pki
	      type: DirectoryOrCreate
	    name: etc-pki
	  - hostPath:
	      path: /etc/kubernetes/pki
	      type: DirectoryOrCreate
	    name: k8s-certs
	  - hostPath:
	      path: /usr/local/share/ca-certificates
	      type: DirectoryOrCreate
	    name: usr-local-share-ca-certificates
	  - hostPath:
	      path: /usr/share/ca-certificates
	      type: DirectoryOrCreate
	    name: usr-share-ca-certificates
	status: {}
```

>`[dryrun] Would write file "/etc/kubernetes/manifests/kube-controller-manager.yaml" with content:`
```yaml
	apiVersion: v1
	kind: Pod
	metadata:
	  creationTimestamp: null
	  labels:
	    component: kube-controller-manager
	    tier: control-plane
	  name: kube-controller-manager
	  namespace: kube-system
	spec:
	  containers:
	  - command:
	    - kube-controller-manager
	    - --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
	    - --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
	    - --bind-address=127.0.0.1
	    - --client-ca-file=/etc/kubernetes/pki/ca.crt
	    - --cluster-name=kubernetes
	    - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
	    - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
	    - --controllers=*,bootstrapsigner,tokencleaner
	    - --kubeconfig=/etc/kubernetes/controller-manager.conf
	    - --leader-elect=true
	    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
	    - --root-ca-file=/etc/kubernetes/pki/ca.crt
	    - --service-account-private-key-file=/etc/kubernetes/pki/sa.key
	    - --use-service-account-credentials=true
	    image: k8s.gcr.io/kube-controller-manager:v1.24.3
	    imagePullPolicy: IfNotPresent
	    livenessProbe:
	      failureThreshold: 8
	      httpGet:
	        host: 127.0.0.1
	        path: /healthz
	        port: 10257
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    name: kube-controller-manager
	    resources:
	      requests:
	        cpu: 200m
	    startupProbe:
	      failureThreshold: 24
	      httpGet:
	        host: 127.0.0.1
	        path: /healthz
	        port: 10257
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    volumeMounts:
	    - mountPath: /etc/ssl/certs
	      name: ca-certs
	      readOnly: true
	    - mountPath: /etc/ca-certificates
	      name: etc-ca-certificates
	      readOnly: true
	    - mountPath: /etc/pki
	      name: etc-pki
	      readOnly: true
	    - mountPath: /usr/libexec/kubernetes/kubelet-plugins/volume/exec
	      name: flexvolume-dir
	    - mountPath: /etc/kubernetes/pki
	      name: k8s-certs
	      readOnly: true
	    - mountPath: /etc/kubernetes/controller-manager.conf
	      name: kubeconfig
	      readOnly: true
	    - mountPath: /usr/local/share/ca-certificates
	      name: usr-local-share-ca-certificates
	      readOnly: true
	    - mountPath: /usr/share/ca-certificates
	      name: usr-share-ca-certificates
	      readOnly: true
	  hostNetwork: true
	  priorityClassName: system-node-critical
	  securityContext:
	    seccompProfile:
	      type: RuntimeDefault
	  volumes:
	  - hostPath:
	      path: /etc/ssl/certs
	      type: DirectoryOrCreate
	    name: ca-certs
	  - hostPath:
	      path: /etc/ca-certificates
	      type: DirectoryOrCreate
	    name: etc-ca-certificates
	  - hostPath:
	      path: /etc/pki
	      type: DirectoryOrCreate
	    name: etc-pki
	  - hostPath:
	      path: /usr/libexec/kubernetes/kubelet-plugins/volume/exec
	      type: DirectoryOrCreate
	    name: flexvolume-dir
	  - hostPath:
	      path: /etc/kubernetes/pki
	      type: DirectoryOrCreate
	    name: k8s-certs
	  - hostPath:
	      path: /etc/kubernetes/controller-manager.conf
	      type: FileOrCreate
	    name: kubeconfig
	  - hostPath:
	      path: /usr/local/share/ca-certificates
	      type: DirectoryOrCreate
	    name: usr-local-share-ca-certificates
	  - hostPath:
	      path: /usr/share/ca-certificates
	      type: DirectoryOrCreate
	    name: usr-share-ca-certificates
	status: {}
```
>`[dryrun] Would write file "/etc/kubernetes/manifests/kube-scheduler.yaml" with content:`
```yaml	
	apiVersion: v1
	kind: Pod
	metadata:
	  creationTimestamp: null
	  labels:
	    component: kube-scheduler
	    tier: control-plane
	  name: kube-scheduler
	  namespace: kube-system
	spec:
	  containers:
	  - command:
	    - kube-scheduler
	    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
	    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
	    - --bind-address=127.0.0.1
	    - --kubeconfig=/etc/kubernetes/scheduler.conf
	    - --leader-elect=true
	    image: k8s.gcr.io/kube-scheduler:v1.24.3
	    imagePullPolicy: IfNotPresent
	    livenessProbe:
	      failureThreshold: 8
	      httpGet:
	        host: 127.0.0.1
	        path: /healthz
	        port: 10259
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    name: kube-scheduler
	    resources:
	      requests:
	        cpu: 100m
	    startupProbe:
	      failureThreshold: 24
	      httpGet:
	        host: 127.0.0.1
	        path: /healthz
	        port: 10259
	        scheme: HTTPS
	      initialDelaySeconds: 10
	      periodSeconds: 10
	      timeoutSeconds: 15
	    volumeMounts:
	    - mountPath: /etc/kubernetes/scheduler.conf
	      name: kubeconfig
	      readOnly: true
	  hostNetwork: true
	  priorityClassName: system-node-critical
	  securityContext:
	    seccompProfile:
	      type: RuntimeDefault
	  volumes:
	  - hostPath:
	      path: /etc/kubernetes/scheduler.conf
	      type: FileOrCreate
	    name: kubeconfig
	status: {}
```
[dryrun] Would write file "/var/lib/kubelet/config.yaml" with content:
```yaml
	apiVersion: kubelet.config.k8s.io/v1beta1
	authentication:
	  anonymous:
	    enabled: false
	  webhook:
	    cacheTTL: 0s
	    enabled: true
	  x509:
	    clientCAFile: /etc/kubernetes/pki/ca.crt
	authorization:
	  mode: Webhook
	  webhook:
	    cacheAuthorizedTTL: 0s
	    cacheUnauthorizedTTL: 0s
	cgroupDriver: systemd
	clusterDNS:
	- 10.96.0.10
	clusterDomain: cluster.local
	cpuManagerReconcilePeriod: 0s
	evictionPressureTransitionPeriod: 0s
	fileCheckFrequency: 0s
	healthzBindAddress: 127.0.0.1
	healthzPort: 10248
	httpCheckFrequency: 0s
	imageMinimumGCAge: 0s
	kind: KubeletConfiguration
	logging:
	  flushFrequency: 0
	  options:
	    json:
	      infoBufferSize: "0"
	  verbosity: 0
	memorySwap: {}
	nodeStatusReportFrequency: 0s
	nodeStatusUpdateFrequency: 0s
	resolvConf: /run/systemd/resolve/resolv.conf
	rotateCertificates: true
	runtimeRequestTimeout: 0s
	shutdownGracePeriod: 0s
	shutdownGracePeriodCriticalPods: 0s
	staticPodPath: /etc/kubernetes/manifests
	streamingConnectionIdleTimeout: 0s
	syncFrequency: 0s
	volumeStatsAggPeriod: 0s
```
[dryrun] Would write file "/var/lib/kubelet/kubeadm-flags.env" with content:
```bash	
KUBELET_KUBEADM_ARGS="--container-runtime=remote --container-runtime-endpoint=unix:///var/run/cri-dockerd.sock --pod-infra-container-image=k8s.gcr.io/pause:3.7"
```
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/tmp/kubeadm-init-dryrun882034531". This can take up to 4m0s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
```yaml
	apiVersion: v1
	data:
	  ClusterConfiguration: |
	    apiServer:
	      extraArgs:
	        authorization-mode: Node,RBAC
	      timeoutForControlPlane: 4m0s
	    apiVersion: kubeadm.k8s.io/v1beta3
	    certificatesDir: /etc/kubernetes/pki
	    clusterName: kubernetes
	    controllerManager: {}
	    dns: {}
	    etcd:
	      local:
	        dataDir: /var/lib/etcd
	    imageRepository: k8s.gcr.io
	    kind: ClusterConfiguration
	    kubernetesVersion: v1.24.3
	    networking:
	      dnsDomain: cluster.local
	      serviceSubnet: 10.96.0.0/12
	    scheduler: {}
	kind: ConfigMap
	metadata:
	  creationTimestamp: null
	  name: kubeadm-config
	  namespace: kube-system
```
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	  creationTimestamp: null
	  name: kubeadm:nodes-kubeadm-config
	  namespace: kube-system
	rules:
	- apiGroups:
	  - ""
	  resourceNames:
	  - kubeadm-config
	  resources:
	  - configmaps
	  verbs:
	  - get
```
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: RoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:nodes-kubeadm-config
	  namespace: kube-system
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: Role
	  name: kubeadm:nodes-kubeadm-config
	subjects:
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
	- kind: Group
	  name: system:nodes
```
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
```yaml
	apiVersion: v1
	data:
	  kubelet: |
	    apiVersion: kubelet.config.k8s.io/v1beta1
	    authentication:
	      anonymous:
	        enabled: false
	      webhook:
	        cacheTTL: 0s
	        enabled: true
	      x509:
	        clientCAFile: /etc/kubernetes/pki/ca.crt
	    authorization:
	      mode: Webhook
	      webhook:
	        cacheAuthorizedTTL: 0s
	        cacheUnauthorizedTTL: 0s
	    cgroupDriver: systemd
	    clusterDNS:
	    - 10.96.0.10
	    clusterDomain: cluster.local
	    cpuManagerReconcilePeriod: 0s
	    evictionPressureTransitionPeriod: 0s
	    fileCheckFrequency: 0s
	    healthzBindAddress: 127.0.0.1
	    healthzPort: 10248
	    httpCheckFrequency: 0s
	    imageMinimumGCAge: 0s
	    kind: KubeletConfiguration
	    logging:
	      flushFrequency: 0
	      options:
	        json:
	          infoBufferSize: "0"
	      verbosity: 0
	    memorySwap: {}
	    nodeStatusReportFrequency: 0s
	    nodeStatusUpdateFrequency: 0s
	    resolvConf: /run/systemd/resolve/resolv.conf
	    rotateCertificates: true
	    runtimeRequestTimeout: 0s
	    shutdownGracePeriod: 0s
	    shutdownGracePeriodCriticalPods: 0s
	    staticPodPath: /etc/kubernetes/manifests
	    streamingConnectionIdleTimeout: 0s
	    syncFrequency: 0s
	    volumeStatsAggPeriod: 0s
	kind: ConfigMap
	metadata:
	  annotations:
	    kubeadm.kubernetes.io/component-config.hash: sha256:000a5dd81630f64bd6f310899359dfb9e8818fc8fe011b7fdc0ec73783a42452
	  creationTimestamp: null
	  name: kubelet-config
	  namespace: kube-system
```
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	  creationTimestamp: null
	  name: kubeadm:kubelet-config
	  namespace: kube-system
	rules:
	- apiGroups:
	  - ""
	  resourceNames:
	  - kubelet-config
	  resources:
	  - configmaps
	  verbs:
	  - get
```
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: RoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:kubelet-config
	  namespace: kube-system
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: Role
	  name: kubeadm:kubelet-config
	subjects:
	- kind: Group
	  name: system:nodes
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
```
[dryrun] Would perform action GET on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "devbox"
[dryrun] Would perform action PATCH on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "devbox"
[dryrun] Attached patch:
```json
	{"metadata":{
		"annotations":{
			"kubeadm.alpha.kubernetes.io/cri-socket":"unix:///var/run/cri-dockerd.sock"
			}
		}
	}
```
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node devbox as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node devbox as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule node-role.kubernetes.io/control-plane:NoSchedule]
[dryrun] Would perform action GET on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "devbox"
[dryrun] Would perform action PATCH on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "devbox"
[dryrun] Attached patch:
```json
	{"metadata":{
		"labels":{
			"node-role.kubernetes.io/control-plane":"",
			"node.kubernetes.io/exclude-from-external-load-balancers":""
			}
		},
		"spec":{
			"taints":[
				{
					"effect":"NoSchedule",
					"key":"node-role.kubernetes.io/master"
				},
				{
					"effect":"NoSchedule",
					"key":"node-role.kubernetes.io/control-plane"}
					]
				}
			}
```
[bootstrap-token] Using token: e6rz96.7vz2ictywjv32yls
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[dryrun] Would perform action GET on resource "secrets" in API group "core/v1"
[dryrun] Resource name: "bootstrap-token-e6rz96"
[dryrun] Would perform action CREATE on resource "secrets" in API group "core/v1"
[dryrun] Attached object:
```yaml
	apiVersion: v1
	data:
	  auth-extra-groups: c3lzdGVtOmJvb3RzdHJhcHBlcnM6a3ViZWFkbTpkZWZhdWx0LW5vZGUtdG9rZW4=
	  description: VGhlIGRlZmF1bHQgYm9vdHN0cmFwIHRva2VuIGdlbmVyYXRlZCBieSAna3ViZWFkbSBpbml0Jy4=
	  expiration: MjAyMi0wOC0wOVQxOToxMDozOFo=
	  token-id: ZTZyejk2
	  token-secret: N3Z6MmljdHl3anYzMnlscw==
	  usage-bootstrap-authentication: dHJ1ZQ==
	  usage-bootstrap-signing: dHJ1ZQ==
	kind: Secret
	metadata:
	  creationTimestamp: null
	  name: bootstrap-token-e6rz96
	  namespace: kube-system
	type: bootstrap.kubernetes.io/token
```
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[dryrun] Would perform action CREATE on resource "clusterroles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRole
	metadata:
	  creationTimestamp: null
	  name: kubeadm:get-nodes
	  namespace: kube-system
	rules:
	- apiGroups:
	  - ""
	  resources:
	  - nodes
	  verbs:
	  - get
```
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:get-nodes
	  namespace: kube-system
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: kubeadm:get-nodes
	subjects:
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
```
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:kubelet-bootstrap
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: system:node-bootstrapper
	subjects:
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
```
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:node-autoapprove-bootstrap
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: system:certificates.k8s.io:certificatesigningrequests:nodeclient
	subjects:
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
```
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:node-autoapprove-certificate-rotation
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
	subjects:
	- kind: Group
	  name: system:nodes
```
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
```yaml
	apiVersion: v1
	data:
	  kubeconfig: |
	    apiVersion: v1
	    clusters:
	    - cluster:
	        certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EZ3dPREU1TVRBek5Gb1hEVE15TURnd05URTVNVEF6TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTXRNCjJDZDdTWk1YaUVsbkdiZmM0T3Flck1IbXA2bUZMenllejlYTitIZG1zaDNuQkVQOEVRamwyYmpXdjRwNnpBb3kKdGVmbHlkeXBBbnVvS1lENWlNbk50Tk1TclI0Z2xUaGJiR0wwdUMrWDhQcS9CcHlNWFdXNk43Z3pud1BHeUF5ZwpIMzFPdVZKeGY3QitrV2cvdzV4Ty9sTWJlc3RUYkFLYkxwUEFWUHRFMTFzRDkvcElRQkg2b0hVR2hwcXF0YmgwCkJWRWVnWENSa1NZV0N4N29nd0pkckJZSWRLY1BNZW9STm41dnpCQzI1bjZnZE9nNnIxMGxEZjBaQm5zY2ZiNFIKaHcySHVtNHRjNWZhdFpjM21uTDdKaGJjMWoydnAwYzJVcTdEWS9aNUdRL1R6SFB5cFBlQ2JlMk5lTjAzemZlSQpZYjduN1dVUXRFbXpsSWZ2QlVrQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZObDVBeDQvMGpMcGsrb0JCWW16dGRGNTI2UEpNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRm1xY2lwOTJHam9rNlRpSC8ragpNQmlnS21QMjV6RzVxMTR5UkpiYm1iSm1UNjNZbDlaVXlLblVydFhuSU9XQk8vZ0RnNzdaWVZzNGZ2dnN0MVRGClFIQlNlWnMwNWduM1BaRzJucGI5aEtGSXFGM05Hd3M2ZTBLbDJXbEU2dWxENHZTdm1wR3BHMDQ2RjdKZU5NRVYKSHdZZnFwdnJ2VEhXUU5UUllnZGtyUm8ySjBxSDZXSWloT2N1QTU3UjFESUhnTkpDL3JuQkV1WUxLSGpyRWt4TQpsR016dk5kMU41R0Z3YzZNZmVlSkpHMXdsQ1BYTWNLUDBTZE1GUU54emR2VDRaOFZTakl4MDJ5b3RMUEZ6eWZoCkdJV1hWSEVXeWFjOUpORjhpejNtVEVkbWpXd05oWXhxMnBoL3dRRStRMjhiNk5tdGVnZXl1UlpYSmQ2TFF6dVIKeWJrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
	        server: https://192.168.47.128:6443
	      name: ""
	    contexts: null
	    current-context: ""
	    kind: Config
	    preferences: {}
	    users: null
	kind: ConfigMap
	metadata:
	  creationTimestamp: null
	  name: cluster-info
	  namespace: kube-public
```
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
```yaml
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	  creationTimestamp: null
	  name: kubeadm:bootstrap-signer-clusterinfo
	  namespace: kube-public
	rules:
	- apiGroups:
	  - ""
	  resourceNames:
	  - cluster-info
	  resources:
	  - configmaps
	  verbs:
	  - get
```
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: RoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:bootstrap-signer-clusterinfo
	  namespace: kube-public
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: Role
	  name: kubeadm:bootstrap-signer-clusterinfo
	subjects:
	- kind: User
	  name: system:anonymous
[dryrun] Would perform action LIST on resource "deployments" in API group "apps/v1"
[dryrun] Would perform action GET on resource "configmaps" in API group "core/v1"
[dryrun] Resource name: "coredns"
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
	apiVersion: v1
	data:
	  Corefile: |
	    .:53 {
	        errors
	        health {
	           lameduck 5s
	        }
	        ready
	        kubernetes cluster.local in-addr.arpa ip6.arpa {
	           pods insecure
	           fallthrough in-addr.arpa ip6.arpa
	           ttl 30
	        }
	        prometheus :9153
	        forward . /etc/resolv.conf {
	           max_concurrent 1000
	        }
	        cache 30
	        loop
	        reload
	        loadbalance
	    }
	kind: ConfigMap
	metadata:
	  creationTimestamp: null
	  name: coredns
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "clusterroles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRole
	metadata:
	  creationTimestamp: null
	  name: system:coredns
	rules:
	- apiGroups:
	  - ""
	  resources:
	  - endpoints
	  - services
	  - pods
	  - namespaces
	  verbs:
	  - list
	  - watch
	- apiGroups:
	  - ""
	  resources:
	  - nodes
	  verbs:
	  - get
	- apiGroups:
	  - discovery.k8s.io
	  resources:
	  - endpointslices
	  verbs:
	  - list
	  - watch
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: system:coredns
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: system:coredns
	subjects:
	- kind: ServiceAccount
	  name: coredns
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "serviceaccounts" in API group "core/v1"
[dryrun] Attached object:
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  creationTimestamp: null
	  name: coredns
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "deployments" in API group "apps/v1"
[dryrun] Attached object:
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  creationTimestamp: null
	  labels:
	    k8s-app: kube-dns
	  name: coredns
	  namespace: kube-system
	spec:
	  replicas: 2
	  selector:
	    matchLabels:
	      k8s-app: kube-dns
	  strategy:
	    rollingUpdate:
	      maxUnavailable: 1
	    type: RollingUpdate
	  template:
	    metadata:
	      creationTimestamp: null
	      labels:
	        k8s-app: kube-dns
	    spec:
	      containers:
	      - args:
	        - -conf
	        - /etc/coredns/Corefile
	        image: k8s.gcr.io/coredns/coredns:v1.8.6
	        imagePullPolicy: IfNotPresent
	        livenessProbe:
	          failureThreshold: 5
	          httpGet:
	            path: /health
	            port: 8080
	            scheme: HTTP
	          initialDelaySeconds: 60
	          successThreshold: 1
	          timeoutSeconds: 5
	        name: coredns
	        ports:
	        - containerPort: 53
	          name: dns
	          protocol: UDP
	        - containerPort: 53
	          name: dns-tcp
	          protocol: TCP
	        - containerPort: 9153
	          name: metrics
	          protocol: TCP
	        readinessProbe:
	          httpGet:
	            path: /ready
	            port: 8181
	            scheme: HTTP
	        resources:
	          limits:
	            memory: 170Mi
	          requests:
	            cpu: 100m
	            memory: 70Mi
	        securityContext:
	          allowPrivilegeEscalation: false
	          capabilities:
	            add:
	            - NET_BIND_SERVICE
	            drop:
	            - all
	          readOnlyRootFilesystem: true
	        volumeMounts:
	        - mountPath: /etc/coredns
	          name: config-volume
	          readOnly: true
	      dnsPolicy: Default
	      nodeSelector:
	        kubernetes.io/os: linux
	      priorityClassName: system-cluster-critical
	      serviceAccountName: coredns
	      tolerations:
	      - key: CriticalAddonsOnly
	        operator: Exists
	      - effect: NoSchedule
	        key: node-role.kubernetes.io/master
	      - effect: NoSchedule
	        key: node-role.kubernetes.io/control-plane
	      volumes:
	      - configMap:
	          items:
	          - key: Corefile
	            path: Corefile
	          name: coredns
	        name: config-volume
	status: {}
[dryrun] Would perform action CREATE on resource "services" in API group "core/v1"
[dryrun] Attached object:
	apiVersion: v1
	kind: Service
	metadata:
	  annotations:
	    prometheus.io/port: "9153"
	    prometheus.io/scrape: "true"
	  creationTimestamp: null
	  labels:
	    k8s-app: kube-dns
	    kubernetes.io/cluster-service: "true"
	    kubernetes.io/name: CoreDNS
	  name: kube-dns
	  namespace: kube-system
	  resourceVersion: "0"
	spec:
	  clusterIP: 10.96.0.10
	  ports:
	  - name: dns
	    port: 53
	    protocol: UDP
	    targetPort: 53
	  - name: dns-tcp
	    port: 53
	    protocol: TCP
	    targetPort: 53
	  - name: metrics
	    port: 9153
	    protocol: TCP
	    targetPort: 9153
	  selector:
	    k8s-app: kube-dns
	status:
	  loadBalancer: {}
[addons] Applied essential addon: CoreDNS
[dryrun] Would perform action CREATE on resource "serviceaccounts" in API group "core/v1"
[dryrun] Attached object:
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  creationTimestamp: null
	  name: kube-proxy
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
	apiVersion: v1
	data:
	  config.conf: |-
	    apiVersion: kubeproxy.config.k8s.io/v1alpha1
	    bindAddress: 0.0.0.0
	    bindAddressHardFail: false
	    clientConnection:
	      acceptContentTypes: ""
	      burst: 0
	      contentType: ""
	      kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
	      qps: 0
	    clusterCIDR: ""
	    configSyncPeriod: 0s
	    conntrack:
	      maxPerCore: null
	      min: null
	      tcpCloseWaitTimeout: null
	      tcpEstablishedTimeout: null
	    detectLocal:
	      bridgeInterface: ""
	      interfaceNamePrefix: ""
	    detectLocalMode: ""
	    enableProfiling: false
	    healthzBindAddress: ""
	    hostnameOverride: ""
	    iptables:
	      masqueradeAll: false
	      masqueradeBit: null
	      minSyncPeriod: 0s
	      syncPeriod: 0s
	    ipvs:
	      excludeCIDRs: null
	      minSyncPeriod: 0s
	      scheduler: ""
	      strictARP: false
	      syncPeriod: 0s
	      tcpFinTimeout: 0s
	      tcpTimeout: 0s
	      udpTimeout: 0s
	    kind: KubeProxyConfiguration
	    metricsBindAddress: ""
	    mode: ""
	    nodePortAddresses: null
	    oomScoreAdj: null
	    portRange: ""
	    showHiddenMetricsForVersion: ""
	    udpIdleTimeout: 0s
	    winkernel:
	      enableDSR: false
	      forwardHealthCheckVip: false
	      networkName: ""
	      rootHnsEndpointName: ""
	      sourceVip: ""
	  kubeconfig.conf: |-
	    apiVersion: v1
	    kind: Config
	    clusters:
	    - cluster:
	        certificate-authority: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
	        server: https://192.168.47.128:6443
	      name: default
	    contexts:
	    - context:
	        cluster: default
	        namespace: default
	        user: default
	      name: default
	    current-context: default
	    users:
	    - name: default
	      user:
	        tokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
	kind: ConfigMap
	metadata:
	  annotations:
	    kubeadm.kubernetes.io/component-config.hash: sha256:44ecdf4ef9aa8073f53b5929e319bb5614e5c0e99bd31f3ac8b42fcc3c549b28
	  creationTimestamp: null
	  labels:
	    app: kube-proxy
	  name: kube-proxy
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "daemonsets" in API group "apps/v1"
[dryrun] Attached object:
	apiVersion: apps/v1
	kind: DaemonSet
	metadata:
	  creationTimestamp: null
	  labels:
	    k8s-app: kube-proxy
	  name: kube-proxy
	  namespace: kube-system
	spec:
	  selector:
	    matchLabels:
	      k8s-app: kube-proxy
	  template:
	    metadata:
	      creationTimestamp: null
	      labels:
	        k8s-app: kube-proxy
	    spec:
	      containers:
	      - command:
	        - /usr/local/bin/kube-proxy
	        - --config=/var/lib/kube-proxy/config.conf
	        - --hostname-override=$(NODE_NAME)
	        env:
	        - name: NODE_NAME
	          valueFrom:
	            fieldRef:
	              fieldPath: spec.nodeName
	        image: k8s.gcr.io/kube-proxy:v1.24.3
	        imagePullPolicy: IfNotPresent
	        name: kube-proxy
	        resources: {}
	        securityContext:
	          privileged: true
	        volumeMounts:
	        - mountPath: /var/lib/kube-proxy
	          name: kube-proxy
	        - mountPath: /run/xtables.lock
	          name: xtables-lock
	        - mountPath: /lib/modules
	          name: lib-modules
	          readOnly: true
	      hostNetwork: true
	      nodeSelector:
	        kubernetes.io/os: linux
	      priorityClassName: system-node-critical
	      serviceAccountName: kube-proxy
	      tolerations:
	      - operator: Exists
	      volumes:
	      - configMap:
	          name: kube-proxy
	        name: kube-proxy
	      - hostPath:
	          path: /run/xtables.lock
	          type: FileOrCreate
	        name: xtables-lock
	      - hostPath:
	          path: /lib/modules
	        name: lib-modules
	  updateStrategy:
	    type: RollingUpdate
	status:
	  currentNumberScheduled: 0
	  desiredNumberScheduled: 0
	  numberMisscheduled: 0
	  numberReady: 0
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  creationTimestamp: null
	  name: kubeadm:node-proxier
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: system:node-proxier
	subjects:
	- kind: ServiceAccount
	  name: kube-proxy
	  namespace: kube-system
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	  creationTimestamp: null
	  name: kube-proxy
	  namespace: kube-system
	rules:
	- apiGroups:
	  - ""
	  resourceNames:
	  - kube-proxy
	  resources:
	  - configmaps
	  verbs:
	  - get
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
	apiVersion: rbac.authorization.k8s.io/v1
	kind: RoleBinding
	metadata:
	  creationTimestamp: null
	  name: kube-proxy
	  namespace: kube-system
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: Role
	  name: kube-proxy
	subjects:
	- kind: Group
	  name: system:bootstrappers:kubeadm:default-node-token
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/tmp/kubeadm-init-dryrun882034531/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.47.128:6443 --token e6rz96.7vz2ictywjv32yls \
	--discovery-token-ca-cert-hash sha256:258fa5ace7b7e106fd4d5a5bc974c7dfe977ffef3a5b5ae2f4638d18e6bc0af1 
