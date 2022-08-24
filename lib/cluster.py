from pathlib import Path
from pykube import Pod

from kubernetes.client import Configuration
from kubernetes.client.api.core_v1_api import CoreV1Api

from lib.pykind.pytest_kind.plugin import *
from lib.pykind.pytest_kind.cluster import *

import docker
class Cluster:
    def __init__(self,*kwargs) -> None:
        """

        """
        self.start_docker_client()
        self.start_kube_client()

    def kubectl_apply_config(self,config_path:Path):
        """
        Uses Kindlib to run kubectl commands with class attribute cluster
        """
        self.cluster.kubectl("apply", "-f", str(config_path.absolute()))

    def start_docker_client(self):
        '''
        Starts a linkage to docker
        '''
        self.docker_client = docker.from_env()
    
    def start_kube_client(self):
        """
        initializes the kubernetes API client
        """
        self.kube_client = client
        self.CoreV1Api = CoreV1Api()
        self.configuration = Configuration

    def get_ca_from_control_plane(self):
        '''
        Gets the CA certificate from control plane
        '''
        self.docker_client.images.get("kindest/node")
