

to run locally built images in Kubernetes, without publishing them to a global registry, have `kubectl` and `kind` installed locally.

> `docker build . -t local_cluster/hello-world`

I can now run a container from this image and see that it works as expected:

> `docker run local_cluster/hello-world`
    
    Hello World!

Next, I create the helloworld.yml configuration file to run this container as a Kubernetes job:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    metadata:
      name: hello-world-pod
    spec:
      containers:
      - name: hello-world
        image: forketyfork/hello-world
      restartPolicy: Never
```

Notice that I’ve specified the name of the image I just built and set the restartPolicy to Never so that it would only run once and terminate.

I now try to create a job out of this configuration file using kubectl:

>`kubectl create -f helloworld.yml`

Let’s check if it worked, using the kubectl get pods command:


> `kubectl get pods`

    NAME              READY STATUS       RESTARTS AGE
    hello-world-lfrzh 0/1   ErrImagePull 0        6s


It didn’t work, and the pod failed with the `ErrImagePull` status. 

The reason is Kubernetes tries to pull the image specified in helloworld.yml, but this image is neither in the minikube docker registry nor in the public Docker registry.

I don’t want to pull this image from a public registry since it’s only available locally. I fix this by setting the imagePullPolicy for the image to Never:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    metadata:
      name: hello-world-pod
    spec:
      containers:
      - name: hello-world
        image: forketyfork/hello-world
        imagePullPolicy: Never
      restartPolicy: Never
```
Let’s remove the job and create it once again:

> `kubectl delete -f helloworld.yml`

    job.batch "hello-world" deleted

> `kubectl create -f helloworld.yml`

    job.batch/hello-world created


> `kubectl get pods`

    NAME              READY STATUS            RESTARTS AGE
    hello-world-r4g9g 0/1   ErrImageNeverPull 0        6s

I now observe another error — `ErrImageNeverPull`.

This means that the minikube node uses its own Docker repository that’s not connected to the Docker registry on the local machine, so without pulling, it doesn’t know where to get the image from.

To fix this, I use the minikube docker-env command that outputs environment variables needed to point the local Docker daemon to the minikube internal Docker registry:

> `minikube docker-env`
    
    export DOCKER_TLS_VERIFY=”1"
    export DOCKER_HOST=”tcp://172.17.0.2:2376"
    export DOCKER_CERT_PATH=”/home/user/.minikube/certs”
    export MINIKUBE_ACTIVE_DOCKERD=”minikube”# To point your shell to minikube’s docker-daemon, run:

`eval $(minikube -p minikube docker-env)`

To apply these variables, I use the proposed command:

> `eval $(minikube -p minikube docker-env)`

I now need to build the image once again, so that it’s installed in the minikube registry, instead of the local one:

> `docker build . -t forketyfork/hello-world`

And recreate the job once again:

> `kubectl delete -f helloworld.yml`
> `kubectl create -f helloworld.yml`

Now kubectl get pods shows that the hello-world pod has completed successfully:

> `kubectl get pods`
    
    NAME              READY STATUS    RESTARTS AGE
    hello-world-f5hzz 0/1   Completed 0        4s

The logs of the pod show that it did what’s expected:

> `kubectl logs hello-world-f5hzz`
    
    Hello World!

One thing to note is that the command eval $(minikube -p minikube docker-env) has to be run in every new terminal window before you build an image. An alternative would be to put it into your .profile file.