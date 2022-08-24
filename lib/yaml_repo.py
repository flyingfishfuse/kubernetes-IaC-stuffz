import yaml
#from util import DEBUG

from textwrap import dedent
# this file contains templates for kubemanage to load and peice together as yaml

class KubeYaml:
	def __init__(self):
		"""
		metaclass to allow the below classes to return yaml objects
		"""
		#self._new_instance()
	
	def _new_instance():
		"""
		returns an empty string to initialize
		"""
		return ""

	def to_yaml(self,finalized_ruleset:str):
		"""
		returns a yaml object
		"""
		return yaml.load(finalized_ruleset)

class Namespace(KubeYaml):
	'''
	Creates a new namespace
	'''
	def __init__(self) -> None:
		"""
		asdf waaat
		"""
		super().__init__()

	def new_namespace(self,namespace:str="kubernetes-dashboard"):
		"""
		call this to return a string in yaml format
		"""
		namespace_yaml = f"""
			apiVersion: v1
			kind: Namespace
			metadata:
			name: {namespace}
			"""
		return dedent(namespace_yaml)

#test_namespace = Namespace()
#asdf = test_namespace.new_namespace()
#print(asdf)

class Deployment(KubeYaml):
	"""
	wat
	"""
	def __init__(self):
		"""
		
		"""
		super().__init__()
		self.namespace = str
		self.final_document = str
		self.services = str
		self.endpoints = str

	def create_service(self,service_name:str):
		"""
		Creates a service for supplied container spec
		final list of services stored in Deployment.services()
		"""
		new_service = Service()
		self.services + new_service.service_yaml(service_name = service_name)


	def deployment_head(self,
						name:str="caldera",
						namespace:str="caldera_namespace",
						app_label:str="caldera"
						)-> str:
		"""
		start a deployment yaml with this
		MUST be FOLLOWED by CONTAINER_SPEC() declarations!!!
		THIS IS NOT OPTIONAL!!
		"""
		deployment_yaml = f'''
			apiVersion: v1
			kind: Deployment
			metadata:
			name: {name}
			namespace: {namespace}
			labels:
				app: {app_label}
			spec:
			containers:
			'''
		return dedent(deployment_yaml)

	def container_spec(self,
						 image_name:str='caldera',
						 image_repo='mitre/caldera',
						 create_service:bool=True
						 )->str:
		"""
		append one of these to the end of a deployment_yaml to add a container spec
		"""
		spec_yaml = f'''# this is for container specs
			- name: {image_name}
			image: {image_repo}
			#args:
		'''

		self.create_service(name = image_name)
		return dedent(spec_yaml)

class Service(KubeYaml):
	"""
	Service yaml representation
	"""
	def __init__(self):
		"""
		waaaat
		"""
		super.__init__()
		self.namespace = "default"

	def base_ruleset(self):
		"""
		Basic Service ruleset for meeplabben
		"""
		ruleset = self.ingress()
		ruleset + self.ingress_path() +self.dashboard_path()

		return ruleset

	def service_yaml(self,
					service_name:str="caldera_service",
					namespace:str="caldera_namespace",
					app_name:str="caldera",
					protocol:str="TCP",
					serve_port:str="80",
					target_port:str="80"
					):
		"""
		yaml string for representation of a kubernetes service
		functions as NodePort type, will not change
		"""
		# TODO figure out name tag in selector field
		service_yaml = f"""apiVersion: v1
			kind: Service
			metadata:
			name: {service_name}
			namespace: {namespace}
			spec:
			selector:
			# dont know which one to use yet
				#app: {app_name}
				app.kubernetes.io/name: {app_name}
			type: NodePort
			ports:
				- protocol: {protocol}
				# the port to serve on
				port: {serve_port}
				# what port to access/proxy to on the POD you are running the application in
				targetPort: {target_port}
			# Default port used by the image
			# this is what port kubernetes is going to be looking for and sending data TO
			"""
		return dedent(service_yaml)

	def endpoint(self,
				 service_name:str="caldera-service",
				 ip_address:str="192.168.47.128",
				 port:str="8082"):
		"""

		"""
		endpoint = f"""apiVersion: v1
			kind: Endpoints
			metadata:
			# the name here should match the name of the Service
			name: {service_name}
			subsets:
			- addresses:
				- ip: {ip_address}
				ports:
				- port: {port}
			"""

		return dedent(endpoint)

class Endpoint(KubeYaml):
	def __init__(self):
		super().__init__()
	
	def new_endpoint(service_name:str="caldera_service",
					 ips_ports:list=[["192.168.1.3","8082"]],
					 port:list="8082"
					):
		"""
		ips_ports should be a list of dual lists
		e.g 
		test = [["192.168.1.1","1234"],["192.168.1.2","1235"],["192.168.1.3","1236"]]
		"""
		for address,port in ips_ports:
			
			#print(address + " --- " + port)
		endpoint = f'''---
					apiVersion: v1
					kind: Endpoints
					metadata:
					# the name here should match the name of the Service
					    name: caldera-service
					subsets:
						- addresses:
							- ip: 192.168.47.128
						ports:
							- port: 8082
					---'''


class Ingress(KubeYaml):
	'''
	yaml for ingress rules

	when instantiated, will return an empty string to begin building your yaml
	'''
	def __init__(self):
		super().__init__()

	def base_ruleset(self):
		"""
		Basic ingress ruleset for meeplabben
		"""
		ruleset = self.ingress()
		ruleset + self.ingress_path() +self.dashboard_path()

		return ruleset

	def ingress(self,
				name:str="cluster-ingress",
				namespace:str="ingress-namespace",
				ingressclassname:str="ingress",
				host:str="devbox.local",):
		"""
		usage example:

		yaml_document = ingress()
		yaml_document + ingress_path()
		final_ingress_ruleset_yamlm = yaml_document + dashboard_path()
		"""
		ingress_yaml = f"""###############################################################################
			# This is for instancing network related infrastructure and assignments
			apiVersion: networking.k8s.io/v1
			kind: Ingress
			metadata:
			name: {name}
			namespace: {namespace}
			annotations:
				nginx.ingress.kubernetes.io/rewrite-target: /
			spec:
			ingressClassName: {ingressclassname}
			rules:
				- host: {host}
				http:
					paths:
			"""
		return dedent(ingress_yaml)

	def ingress_path(ingress_name:str="/caldera",
					 service_name:str="caldera-service",
					 port:str="80"
					 ):
		"""
		yaml for adding to the ingress
		each one is a path to be created
		"""
		ingress_path_yaml = f"""			- pathType: Prefix
			path: "{ingress_name}"
			backend:
				service:
				name: {service_name}
				port:
					number: {port}
"""
		return ingress_path_yaml

	def dashboard_path():
		"""
		premade path for dashboard
		"""
	
		dashboard_path_yaml = f"""			- pathType: Prefix
			path: "/dashboard"
			backend:
				service:
				name: "dashboard"
				port:
					number: 80
"""
		return dashboard_path_yaml

# debugging purposes only
if __name__ == "__main__" and DEBUG == True:
	# create classes
	deployment_test = Deployment()
	# TODO: have these created automatically, by extracting values to fill params
	service_test = Service()
	ingress_test = Ingress()

	# create the head, only do this once
	deployment = deployment_test.deployment_head(name = "test-deployment",
												 namespace="test-deployment",
												 app_label="test-app"
												)
	# create a specification for a new container
	# you can do this as many times as you want, one for each container
	# the default is to start a caldera instance
	deployment + deployment_test.container_spec()
	deployment + deployment_test.container_spec(image_name="wordpress", image_repo="wordpress")
	#deployment + 

	wat = Ingress()
	yaml_document = wat.ingress()
	yaml_document + wat.ingress_path()
	final_ingress_ruleset_yaml = yaml_document + wat.dashboard_path()
	print(final_ingress_ruleset_yaml)

	test = [["192.168.1.1","1234"],["192.168.1.2","1235"],["192.168.1.3","1236"]]
	endpoint = Endpoint()
	endpoint.new_endpoint(ips_ports=test)