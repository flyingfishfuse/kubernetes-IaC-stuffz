import os, sys
import yaml
from pathlib import Path
from docs.__docs__ import *

import pprint

from docker import client

import time

from pykube import Pod
import requests
from ipaddress import IPv4Address

import kubernetes
from kubernetes import config
from kubernetes.client import Configuration
from kubernetes.client.api import core_v1_api
from kubernetes.client.api.core_v1_api import CoreV1Api
from kubernetes.client.rest import ApiException
from kubernetes.stream import portforward

from lib.pykind.pytest_kind import plugin,cluster,KindCluster
from lib.pykind.pytest_kind.plugin import *
from lib.pykind.pytest_kind.cluster import *

import docker

from lib.cluster import Cluster
from lib.util import *

class KubernetesManagment(Cluster):
    def __init__(self,
                kubeconfig:Path,
                PROJECT_ROOT:Path,
                LIB_ROOT:Path,
                BIN_ROOT:Path,
                YAML_REPO:Path,
                CLUSTER_ROLE_CONFIG:str,
                CLUSTER_ROLE_CONFIG_BINDING:str
                ):
        """
        kubeconfig is optional but if you dont supply it you will need to use

        >>> KubernetesManagment.load_kubeconfig(Path_to_config)

        BEFORE you do anything requiring a config... which is pretty much anything
        """
        # Configs can be set in Configuration class directly or using helper
        # utility. If no argument provided, the config will be loaded from
        # default location.
        self.projectroot = PROJECT_ROOT
        self.libroot = LIB_ROOT
        self.binroot = BIN_ROOT
        self.YAML_REPO = YAML_REPO
        self.CLUSTER_ROLE_CONFIG = CLUSTER_ROLE_CONFIG
        self.CLUSTER_ROLE_CONFIG_BINDING = CLUSTER_ROLE_CONFIG_BINDING

        self.namespaces = []
        # need various things from config like registry name
        # the registry in use
        self.registry_str = str
        # cluster namespace
        self.cluster_namespace = 'meeplabben'
        # list of pods in cluster
        self.pods_list= dict
        #self.internal_ip = IPv4Address

    
    def set_kubeconfig_location(self):
        '''
        Sets kubernetes config location
        '''

    def load_kube_config(self,config_file:Path):
        """
        Loads the given config, with the given context, into the class

        Use this method to reload a config or switch contexts

A kubeconfig needs the following important details.

    Cluster endpoint (IP or DNS name of the cluster)\n
    Cluster CA Certificate\n
    Cluster name \n
    Service account user name\n
    Service account token\n
        """
        self.kubeconfig = config.load_kube_config(str(config_file.absolute()))

    def init_dashboard(self):
        '''
        create an admin binding for the control panel and instance the pod/proxy
        '''
        self.cluster.kubectl("apply", "-f", str(Path(self.YAML_REPO,"create_admin_in_dashboard.yml")))
        self.cluster.kubectl("apply", "-f", str(Path(self.YAML_REPO,"create_dashboard_user_binding.yml")))
        self.cluster.kubectl("proxy")
        
    def create_service_account(self):
        '''
        makes a call to the binary using subprocess.popen()
        creating a service account with kubectl command :

        >>> kubectl -n kube-system create serviceaccount devops-cluster-admin
        '''
        self.create_cluster_role()
        self.create_cluster_role_binding()

    def create_cluster_role(self,username:str,namespace:str, cli:bool=False):
        """
        Uses kubectl to apply cluster roles
        """
        greenprint("[+] Creating cluster role")
        if cli == True:
            #elf.kubectl_apply_config(Path(self.projectroot,self.CLUSTER_ROLE_CONFIG))
            self.cluster.kubectl("-n", namespace, "create", "serviceaccount", username)
        elif cli == False:
            with self.kube_client.ApiClient(self.configuration) as api_client:
            # Create an instance of the API class
                api_instance = kubernetes.client.RbacAuthorizationV1Api(api_client)
                body = kubernetes.client.V1ClusterRole() # V1ClusterRole | 
            pretty = 'pretty_example' # str | If 'true', then the output is pretty printed. (optional)
            dry_run = 'dry_run_example' # str | When present, indicates that modifications should not be persisted. An invalid or unrecognized dryRun directive will result in an error response and no further processing of the request. Valid values are: - All: all dry run stages will be processed (optional)
            field_manager = 'field_manager_example' # str | fieldManager is a name associated with the actor or entity that is making these changes. The value must be less than or 128 characters long, and only contain printable characters, as defined by https://golang.org/pkg/unicode/#IsPrint. (optional)
            field_validation = 'field_validation_example' # str | fieldValidation instructs the server on how to handle objects in the request (POST/PUT/PATCH) containing unknown or duplicate fields, provided that the `ServerSideFieldValidation` feature gate is also enabled. Valid values are: - Ignore: This will ignore any unknown fields that are silently dropped from the object, and will ignore all but the last duplicate field that the decoder encounters. This is the default behavior prior to v1.23 and is the default behavior when the `ServerSideFieldValidation` feature gate is disabled. - Warn: This will send a warning via the standard warning response header for each unknown field that is dropped from the object, and for each duplicate field that is encountered. The request will still succeed if there are no other errors, and will only persist the last of any duplicate fields. This is the default when the `ServerSideFieldValidation` feature gate is enabled. - Strict: This will fail the request with a BadRequest error if any unknown fields would be dropped from the object, or if any duplicate fields are present. The error returned from the server will contain all unknown and duplicate fields encountered. (optional)

            try:
                api_response = api_instance.create_cluster_role(body, pretty=pretty, dry_run=dry_run, field_manager=field_manager, field_validation=field_validation)
                pprint(api_response)
            except ApiException as e:
                errorlogger("Exception when calling RbacAuthorizationV1Api->create_cluster_role: %s\n" % e)
    
    def create_cluster_role_binding(self):#,username):
        '''
        create cluster role binding for kubernetes
        '''
        greenprint("[+] Creating cluster role binding")
        #self.kubectl_apply_config(Path(self.libroot,self.CLUSTER_ROLE_CONFIG_BINDING))
        try:
            api_response = api_instance.create_cluster_role_binding(body, pretty=pretty, dry_run=dry_run, field_manager=field_manager, field_validation=field_validation)
            pprint(api_response)
        except ApiException as e:
            print("Exception when calling RbacAuthorizationV1Api->create_cluster_role_binding: %s\n" % e)
    
    def set_registry(self, registry_string:str):
        '''
        Unnecessary if using the LOCAL cluster features
        '''
        if len(registry_string) == 0 or registry_string == None:
            pass
        else:
            self.registry = registry_string
    

    def init_client(self, name="default", clustertype="kind"):
        '''
        establishes the client for the cluster, api handler function
        '''
        greenprint("[+] Initializing Kubernetes cluster manager")
        self.kubeconfig.load_kube_config()
        config = Configuration.get_default_copy()
        config.assert_hostname = False
        Configuration.set_default(config)
        self.core_v1 = core_v1_api.CoreV1Api()
    
    def deploy_object(self,yaml_block:str):
        """
        Uses built in yaml blocks to define and deploy an object into the cluster

        used with 
        
        >>> ruleset = Ingress()
        ""
        >>> ruleset = ruleset.ingress()
        
        >>> ruleset = ruleset.ingress_path() + self.dashboard_path()
        
        """
        dep = yaml.safe_load(yaml_block)
        #k8s_apps_v1 = client.AppsV1Api()
        resp = self.CoreV1Api.create_namespaced_deployment(
            body=dep, namespace="default")
        print("Deployment created. status='%s'" % resp.metadata.name)

    def deploy_pod(self,config_path:Path,cluster_namespace = "default"):
        '''
        Deploys a pod with given yml manifest \n
        Do not use on deployed pods that are already running, \n
        that will simply create another and increase overhead  \n
        For those you must reload, or remove/recreate.
        
        '''
        with open(os.path.join(os.path.dirname(__file__), str(config_path.absolute()))) as deployment_yaml:
            dep = yaml.safe_load(deployment_yaml)
            k8s_apps_v1 = client.AppsV1Api()
            cluster_response = k8s_apps_v1.create_namespaced_deployment(
                body=dep, namespace=cluster_namespace)
            greenprint("[+] Deployment created. status='%s'" % cluster_response.metadata.name)

    def port_forward_to_pod(self, namespace:str,host_port:int,pod_port:int, api_instance:CoreV1Api):
        '''
        This requires kubectl be in the path, I looked at the python implementation
        and decided a  direct call to the application is easier and cleaner to implement
        '''

    def kind_port_forward(self, namespace:str,host_port:int,pod_port:int):
        '''
        Uses pykind to establish a port forward
        '''
        self.cluster.port_forward(pod_port)

    def deploy_pod_from_json(self,json_container):
        '''
        uses a json container as manifest, more pythonic way of creating a pod
        '''
        name=json_container["metadata"]["name"]
        greenprint(f"[+] Deploying Pod {name}")
        self.core_v1.create_namespaced_pod(body=json_container,
                                           namespace=self.cluster_namespace)
        while True:
            resp = self.core_v1.read_namespaced_pod(name=name,
                                                    namespace=self.cluster_namespace)
            if resp.status.phase != 'Pending':
                break
            time.sleep(1)
        greenprint("[+] Pod deployed")

    def get_ports_in_use(self):
        '''
        gets ports being used on HOST SERVER by kubernetes
        '''
    def list_active_pods(self):
        '''
        lists all currently running pods and status
        Can filter by category, difficulty,and popularity
        '''

    def list_all_pods(self):
        """
        lists all pods, running and inactive
        """
        
        print("Listing pods with their IPs:")
        ret = v1.list_pod_for_all_namespaces(watch=False)
        for i in ret.items:
            print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
    
    def _init_nginx(self,path:Path):
        """
        from docs/examples

        The nginx yaml resides in $PROJECTROOT/containers/nginx
        """
        with open(path.join(path.dirname(__file__), "nginx-deployment.yaml")) as f:
            dep = yaml.safe_load(f)
            k8s_apps_v1 = client.AppsV1Api()
            resp = k8s_apps_v1.create_namespaced_deployment(
                body=dep, namespace="default")
            print("Deployment created. status='%s'" % resp.metadata.name)
