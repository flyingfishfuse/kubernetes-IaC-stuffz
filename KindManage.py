

    def init_client(self, name="default", clustertype="kind"):
        '''
        establishes the client for the cluster, api handler function
        '''
        if clustertype=="kind":
            greenprint("[+] Initializing Kind cluster manager")
            self.cluster = KindCluster(name)


    def create_cluster(self,kube_config:Path,name="default"):
        f'''
        Kind function
        creates a cluster with Kind or kubernetes
        {kind_cluster_create}

        Sets namespace to "Default" by default
        '''
        self.cluster = KindCluster(name)
        self.cluster.create()
        if kube_config == None:
            greenprint("[+] Using LOCAL config")
            self.cluster.kubectl("apply", "-f", self.kubeconfig)
        else:
            greenprint("[+] using USER-SUPPLIED kubeconfig")
            self.cluster.kubectl("apply", "-f", kube_config)
        
    def stop_Kind_cluster(self,name="default"):
        '''
        Stops the named Kind Cluster
        '''

    def delete_Kind_cluster(self):
        ''' does what it says on the box, be careful using this'''
        self.cluster.delete()

    def kind_deploy_container(self,kind_cluster:KindCluster,container:str):
        """
        Uses Kind to deploy pods
        """
        kind_cluster.load_docker_image(container)
        kind_cluster.kubectl("apply", "-f", "deployment.yaml")
        kind_cluster.kubectl("rollout", "status", "deployment/myapp")

        # using Pykube to query pods
        for pod in Pod.objects(kind_cluster.api).filter(selector="app=myapp"):
            assert "Sucessfully started" in pod.logs()

        with kind_cluster.port_forward("service/myapp", 80) as port:
            r = requests.get(f"http://localhost:{port}/hello/world")
            r.raise_for_status()
            assert r.text == "Hello world!"