Container Runtimes
Note: Dockershim has been removed from the Kubernetes project as of release 1.24. Read the Dockershim Removal FAQ for further details.

You need to install a container runtime into each node in the cluster so that Pods can run there. This page outlines what is involved and describes related tasks for setting up nodes.

Kubernetes 1.24 requires that you use a runtime that conforms with the Container Runtime Interface (CRI).

See CRI version support for more information.

This page provides an outline of how to use several common container runtimes with Kubernetes.

    containerd
    CRI-O
    Docker Engine
    Mirantis Container Runtime

Note:

Kubernetes releases before v1.24 included a direct integration with Docker Engine, using a component named dockershim. That special direct integration is no longer part of Kubernetes (this removal was announced as part of the v1.20 release). You can read Check whether Dockershim removal affects you to understand how this removal might affect you. To learn about migrating from using dockershim, see Migrating from dockershim.

If you are running a version of Kubernetes other than v1.24, check the documentation for that version.
Install and configure prerequisites

The following steps apply common settings for Kubernetes nodes on Linux.

You can skip a particular setting if you're certain you don't need it.

For more information, see Network Plugin Requirements or the documentation for your specific container runtime.
Forwarding IPv4 and letting iptables see bridged traffic

Verify that the br_netfilter module is loaded by running lsmod | grep br_netfilter.

To load it explicitly, run sudo modprobe br_netfilter.

In order for a Linux node's iptables to correctly view bridged traffic, verify that net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config. For example:

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

```

Cgroup drivers

On Linux, control groups are used to constrain resources that are allocated to processes.

When systemd is chosen as the init system for a Linux distribution, the init process generates and consumes a root control group (cgroup) and acts as a cgroup manager. Systemd has a tight integration with cgroups and allocates a cgroup per systemd unit. It's possible to configure your container runtime and the kubelet to use cgroupfs. Using cgroupfs alongside systemd means that there will be two different cgroup managers.

A single cgroup manager simplifies the view of what resources are being allocated and will by default have a more consistent view of the available and in-use resources. When there are two cgroup managers on a system, you end up with two views of those resources. In the field, people have reported cases where nodes that are configured to use cgroupfs for the kubelet and Docker, but systemd for the rest of the processes, become unstable under resource pressure.

Changing the settings such that your container runtime and kubelet use systemd as the cgroup driver stabilized the system. To configure this for Docker, set native.cgroupdriver=systemd.
Caution:

Changing the cgroup driver of a Node that has joined a cluster is a sensitive operation. If the kubelet has created Pods using the semantics of one cgroup driver, changing the container runtime to another cgroup driver can cause errors when trying to re-create the Pod sandbox for such existing Pods. Restarting the kubelet may not solve such errors.

If you have automation that makes it feasible, replace the node with another using the updated configuration, or reinstall it using automation.
Cgroup version 2

Cgroup v2 is the next version of the cgroup Linux API. Differently than cgroup v1, there is a single hierarchy instead of a different one for each controller.

The new version offers several improvements over cgroup v1, some of these improvements are:

    cleaner and easier to use API
    safe sub-tree delegation to containers
    newer features like Pressure Stall Information

Even if the kernel supports a hybrid configuration where some controllers are managed by cgroup v1 and some others by cgroup v2, Kubernetes supports only the same cgroup version to manage all the controllers.

If systemd doesn't use cgroup v2 by default, you can configure the system to use it by adding systemd.unified_cgroup_hierarchy=1 to the kernel command line.

```bash
# This example is for a Linux OS that uses the DNF package manager
# Your system might use a different method for setting the command line
# that the Linux kernel uses.
sudo dnf install -y grubby && \
  sudo grubby \
  --update-kernel=ALL \
  --args="systemd.unified_cgroup_hierarchy=1"
```
If you change the command line for the kernel, you must reboot the node before your change takes effect.

There should not be any noticeable difference in the user experience when switching to cgroup v2, unless users are accessing the cgroup file system directly, either on the node or from within the containers.

In order to use it, cgroup v2 must be supported by the CRI runtime as well.
Migrating to the systemd driver in kubeadm managed clusters

If you wish to migrate to the systemd cgroup driver in existing kubeadm managed clusters, follow configuring a cgroup driver.
CRI version support

Your container runtime must support at least v1alpha2 of the container runtime interface.

Kubernetes 1.24 defaults to using v1 of the CRI API. If a container runtime does not support the v1 API, the kubelet falls back to using the (deprecated) v1alpha2 API instead.
Container runtimes
Note: This section links to third party projects that provide functionality required by Kubernetes. The Kubernetes project authors aren't responsible for these projects, which are listed alphabetically. To add a project to this list, read the content guide before submitting a change. More information.
containerd

This section outlines the necessary steps to use containerd as CRI runtime.

Use the following commands to install Containerd on your system:

Follow the instructions for getting started with containerd. Return to this step once you've created a valid configuration file, config.toml.

    Linux
    Windows

You can find this file under the path /etc/containerd/config.toml.

On Linux the default CRI socket for containerd is /run/containerd/containerd.sock. On Windows the default CRI endpoint is npipe://./pipe/containerd-containerd.
Configuring the systemd cgroup driver

To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set
```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```
Note:

If you installed containerd from a package (for example, RPM or .deb), you may find that the CRI integration plugin is disabled by default.

You need CRI support enabled to use containerd with Kubernetes. Make sure that cri is not included in thedisabled_plugins list within /etc/containerd/config.toml; if you made changes to that file, also restart containerd.

If you apply this change, make sure to restart containerd:

>`sudo systemctl restart containerd`

When using kubeadm, manually configure the cgroup driver for kubelet.
Overriding the sandbox (pause) image

In your containerd config you can overwrite the sandbox image by setting the following config:
```conf
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "k8s.gcr.io/pause:3.2"
```
You might need to restart containerd as well once you've updated the config file: systemctl restart containerd.
CRI-O

This section contains the necessary steps to install CRI-O as a container runtime.

To install CRI-O, follow CRI-O Install Instructions.
cgroup driver

CRI-O uses the systemd cgroup driver per default, which is likely to work fine for you. To switch to the cgroupfs cgroup driver, either edit /etc/crio/crio.conf or place a drop-in configuration in /etc/crio/crio.conf.d/02-cgroup-manager.conf, for example:

```conf
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "cgroupfs"
```
You should also note the changed conmon_cgroup, which has to be set to the value pod when using CRI-O with cgroupfs. It is generally necessary to keep the cgroup driver configuration of the kubelet (usually done via kubeadm) and CRI-O in sync.

For CRI-O, the CRI socket is /var/run/crio/crio.sock by default.
Overriding the sandbox (pause) image

In your CRI-O config you can set the following config value:
```conf
[crio.image]
pause_image="registry.k8s.io/pause:3.6"
```
This config option supports live configuration reload to apply this change: systemctl reload crio or by sending SIGHUP to the crio process.
Docker Engine
Note: These instructions assume that you are using the cri-dockerd adapter to integrate Docker Engine with Kubernetes.

    On each of your nodes, install Docker for your Linux distribution as per Install Docker Engine.

    Install cri-dockerd, following the instructions in that source code repository.

For cri-dockerd, the CRI socket is /run/cri-dockerd.sock by default.
Overriding the sandbox (pause) image

The cri-dockerd adapter accepts a command line argument for specifying which container image to use as the Pod infrastructure container (“pause image”). The command line argument to use is --pod-infra-container-image.
Mirantis Container Runtime

Mirantis Container Runtime (MCR) is a commercially available container runtime that was formerly known as Docker Enterprise Edition.

You can use Mirantis Container Runtime with Kubernetes using the open source cri-dockerd component, included with MCR.

To learn more about how to install Mirantis Container Runtime, visit MCR Deployment Guide.

Check the systemd unit named cri-docker.socket to find out the path to the CRI socket.
Overriding the sandbox (pause) image

The cri-dockerd adapter accepts a command line argument for specifying which container image to use as the Pod infrastructure container (“pause image”). The command line argument to use is --pod-infra-container-image