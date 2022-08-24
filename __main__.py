from lib.KubeManage import KubernetesManagment

from lib.util import *
from docs.__docs__ import *
import subprocess
################################################################################
##############				   Master Values				 #################
################################################################################

sys.path.insert(0, os.path.abspath('.'))

#Before we load the menu, we need to do some checks
# The .env needs to be reloaded in the case of other alterations
#
# Where the terminal is located when you run the file
PWD = os.path.realpath(".")
#PWD_LIST = os.listdir(PWD)

# ohh look a global list

global PROJECT_ROOT
try:
    PROJECT_ROOT = Path(os.path.dirname(__file__))
except:
    PROJECT_ROOT = Path(os.path.dirname(PWD))

debuggreen(f"PROJECT_ROOT: {PROJECT_ROOT}")
os.environ["PROJECT_ROOT"] = str(PROJECT_ROOT.absolute())

global BIN_ROOT
BIN_ROOT=Path(PROJECT_ROOT,'bin')
os.environ["BIN_ROOT"] = str(BIN_ROOT.absolute())
debuggreen(f"BIN_ROOT: {BIN_ROOT}")

global LIB_ROOT
LIB_ROOT = Path(PROJECT_ROOT,'lib')
os.environ["LIB_ROOT"] = str(LIB_ROOT.absolute())
debuggreen(f"LIB_ROOT: {LIB_ROOT}")

global YAML_REPO
YAML_REPO = Path(LIB_ROOT,"yaml_repo")
debuggreen(f"YAML_REPO: {YAML_REPO}")

global KUBECONFIGPATH
KUBECONFIGPATH = Path(YAML_REPO,'kubeconfig.yml')
os.environ["KUBECONFIGPATH"] = str(KUBECONFIGPATH.absolute())
debuggreen(f"KUBECONFIGPATH: {KUBECONFIGPATH}")

CLUSTER_ROLE_CONFIG =         Path(YAML_REPO,"cluster_role_config.yml")
CLUSTER_ROLE_CONFIG_BINDING = Path(YAML_REPO,"cluster_role_config_binding.yml")
CLUSTER_DASHBOARD =           Path(YAML_REPO,"kubernetes_dashboard.yml")

#debuggreen(f"CLUSTER_ROLE_CONFIG :{CLUSTER_ROLE_CONFIG}")
#debuggreen(f"CLUSTER_ROLE_CONFIG :{CLUSTER_ROLE_CONFIG}")
list_of_critical_vars = ["PROJECT_ROOT","LIB_ROOT","BIN_ROOT","KUBECONFIGPATH","CLUSTER_ROLE_CONFIG","CLUSTER_ROLE_CONFIG_BINDING"]
###############################################################################
##					 Docker Information									##
###############################################################################

class KindWrapper():
    def __init__(self,kind_bin_path:Path):
        self.binary_path = str(kind_bin_path.absolute())
    
    def create_cluster(self,namespace:str,kubeconfig_path:Path):
        """
        creates a cluster with given config
        """
    

def showenv():
    '''
    Checks shell env vars for required data
    '''
    for thing in os.getenv():
        if thing in list_of_critical_vars:
            greenprint(f"[+] {thing}")

def setpath():
    '''
    Establishes paths for tooling (kind, docker, etc...)
    '''
    sys.path.insert(0,str(BIN_ROOT))

def create_certificate_authority():
    """
    Creates a certificate authority using a shell script
    """
    greenprint("[+] Generating CA data using script 'init_ca.sh'")
    subprocess.Popen(f"sh -c {PROJECT_ROOT}/init_ca.sh")


# create your own custom scripts with ease!
def establish_host(cluster_reference:KubernetesManagment):
    """
    Performs setup of a cluster, use this before creating a cluster
    """
    #setpath()
    #cluster_reference.create_service_account("cluster_admin")
    #cluster_reference
    
def init_manager() -> KubernetesManagment:
    """
    Creates an instance of KubernetesManagment class
    """
    ClusterManager = KubernetesManagment(kubeconfig=KUBECONFIGPATH,
                                         PROJECT_ROOT=PROJECT_ROOT,
                                         LIB_ROOT=LIB_ROOT,
                                         BIN_ROOT=BIN_ROOT,
                                         YAML_REPO=YAML_REPO,
                                         CLUSTER_ROLE_CONFIG=CLUSTER_ROLE_CONFIG,
                                         CLUSTER_ROLE_CONFIG_BINDING=CLUSTER_ROLE_CONFIG_BINDING
                                         )
    return ClusterManager

def init_dashboard(cluster_manager:KubernetesManagment):
    '''
    Deploys the kubernetes dashboard at
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
    '''
    try:
        #apply dashboard config
        clustermanager.kubectl_apply_config(CLUSTER_DASHBOARD)
        cluster_manager.make_thefucking_dashboard_fucking_work()
        # init proxy service
        cluster_manager.cluster.kubectl("proxy")
        greenprint("[+] Dashboard is running on http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/")
    except:
        errorlogger("Cannot deploy dashboard, check the log file")

def createsandbox(cluster_manager:KubernetesManagment):
    '''
	Creates the sandbox, using kubernetes/docker
	'''
	# set environment to read from kube config directory
    #setenv({"KUBECONFIG":KUBECONFIGPATH})
	#TODO: make this

    cluster_manager.init_client()
    cluster_manager.create_cluster_role()
    cluster_manager.create_cluster_role_binding()
    cluster_manager.create_cluster()

def runsandbox(composefile):
	'''
	run a sandbox

	Args:
		composefile (str): composefile to use
	'''
	#subprocess.Popen(["docker-compose", "up", composefile])

if __name__ == "__main__":
    clustermanager = init_manager()
    init_dashboard(cluster_manager=clustermanager)
    #createsandbox(cluster_manager=clustermanager)