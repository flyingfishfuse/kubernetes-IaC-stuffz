## required packages

>`Kubernetes`
```bash 
source ~/Desktop/sysadmin_package/flange.sh /
install_golang_single_user && /
setup_for_kubernetes && /
install_kubernetes
```

>`cri-dockerd from mirantis`

cri-dockerd is a "shim" that inserts between kubernetes and docker to implement Continer runtime interface for docker containers that
deviate from CRI in releases past (insert release version here)

```bash
https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.5/cri-dockerd_0.2.5.3-0.debian-buster_amd64.deb
sudo dpkg -i cri-dockerd_0.2.5.3-0.debian-buster_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo systemctl start cri-docker.service cri-docker.socket
```

the default network plugin for `cri-dockerd` is set to `cni` on Linux. To change this, `--network-plugin=${plugin}`
can be passed in as a command line argument if invoked manually, or the systemd unit file
(`/usr/lib/systemd/system/cri-docker.service` if not enabled yet,
or `/etc/systemd/system/multi-user.target.wants/cri-docker.service` as a symlink if it is enabled) should be
edited to add this argument, followed by `systemctl daemon-reload` and restarting the service (if running)

```shell
git clone https://github.com/Mirantis/cri-dockerd.git
```

The above step creates a local directory called ```cri-dockerd``` which you will need for the following steps.

To build this code (in a POSIX environment):

```bash
mkdir bin
VERSION=$((git describe --abbrev=0 --tags | sed -e 's/v//') || echo $(cat VERSION)-$(git log -1 --pretty='%h')) PRERELEASE=$(grep -q dev <<< "${VERSION}" && echo "pre" || echo "") REVISION=$(git log -1 --pretty='%h')
go build -ldflags="-X github.com/Mirantis/cri-dockerd/version.Version='$VERSION}' -X github.com/Mirantis/cri-dockerd/version.PreRelease='$PRERELEASE' -X github.com/Mirantis/cri-dockerd/version.BuildTime='$BUILD_DATE' -X github.com/Mirantis/cri-dockerd/version.GitCommit='$REVISION'" -o cri-dockerd
```

To build for a specific architecture, add `ARCH=` as an argument, where `ARCH` is a known build target for golang

To install, on a Linux system that uses systemd, and already has Docker Engine installed

```bash
# Run these commands as root
###Install GO###
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
./installer_linux
source ~/.bash_profile

cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
```


`OR`
```bash
    source ~/Desktop/sysadmin_package/flange.sh /
    install_cri_dockerd && /
    systemctl daemon-reload
    systemctl enable cri-docker.service
    systemctl enable --now cri-docker.socket
    sudo systemctl start cri-docker.service cri-docker.socket
```
# rootless containers and NERDCTL

>`to install nerdctl for rootless operation:`
```bash
curl -LJO https://github.com/containerd/nerdctl/releases/download/v0.22.2/nerdctl-full-0.22.2-linux-amd64.tar.gz
sudo apt install rootlesskit uidmap
tar -xvf nerdctl-full-0.22.2-linux-amd64.tar.gz --directory /home/USERNAME/.local/
###
# this doesnt work for some reason, insert that line manually after file creation with touch
sudo echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.d/99-rootless.conf && sudo cat /etc/sysctl.d/99-rootless.conf
###
sudo touch /etc/sysctl.d/99-rootless.conf
sudo nano /etc/sysctl.d/99-rootless.conf
# add the following lines and save+exit
# net.ipv4.ip_unprivileged_port_start=0
# kernel.unprivileged_userns_clone=1
sudo sysctl --system
```

## Enabling cgroup v2

> `Enabling cgroup v2 for containers requires kernel 4.15 or later. Kernel 5.2 or later is recommended.`

> `delegating cgroup v2 controllers to non-root users requires a recent version of systemd. systemd 244 or later is recommended.`

    TO CHECK:
        ls /sys/fs/cgroup/cgroup.controllers
    should return the file listing

    ELSE:
    To boot the host with cgroup v2, add the following string to the `GRUB_CMDLINE_LINUX` line in `/etc/default/grub` and then run `sudo update-grub`

        systemd.unified_cgroup_hierarchy=1

## Enabling CPU, CPUSET, and I/O delegation

> `By default, a non-root user can only get memory controller and pids controller to be delegated.`

```bash
cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.controllers
memory pids
```
To allow delegation of other controllers such as cpu, cpuset, and io, run the following commands:

```bash
sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload
```


## Configure the kubelet to use cri-dockerd (per node, during upgrade from kubectl > 1.24, if not upgrading ignore this)

test the socket connection:
>`sudo kubeadm config images pull --cri-socket /run/cri-dockerd.sock`

enable docker socket usage
>`nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf`

    ADD:
      KUBELET_KUBEADM_ARGS="... --container-runtime=remote --container-runtime-endpoint=/run/cri-dockerd.sock"

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network


# establishing DNS for the container/cluster host

You *may* need to run the following command to allow systemd to access the `resolved` service. 
On a new Debian install it was necesary

>`sudo ln -sf /lib/systemd/system/systemd-resolved.service /etc/systemd/system/dbus-org.freedesktop.resolve1.service`


# Setting kernel options for flannel networking

```bash
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
```

