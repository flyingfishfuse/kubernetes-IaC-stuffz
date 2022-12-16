# installing tooling for kubernetes with dockerd

## A quick breakdown
0. If using WSL2, upgrade Debian Stretch to Bullseye
1. install docker
  * windows(wsl2)
  * linux
2. install cri-dockerd
  * windows(wsl2)
  * linux
3. install kubelet/kubeadm/kubectl
  * windows(wsl2)
  * linux
4. install helm
  * windows(wsl2)
  * linux

> NOTE: `systemd in WSL2 does not function as expected as WSL2 has its own init "system" that is a hybrid of host/container operations`

## upgrade WSL2 Debian(Stretch) to Debian(Bullseye)
1. Begin by backing up your WSL2 container in POWERSHELL

navigate to the directory you wish to backup the WSL2 distribution in then run the following command
```powershell
wsl --export Debian debian10.tar
```

2. Update and upgrade all current packages to prepare for full system upgrade
```bash
sudo apt-get update && sudo apt-get upgrade
```

3. Add the official repositories for Bullseye to your `/etc/apt/sources.d`
`COMMENT OUT THE PREVIOUS STRETCH REPOSITORIES`

```shell
deb http://deb.debian.org/debian bullseye main
deb http://deb.debian.org/debian bullseye-updates main
deb http://security.debian.org/debian-security bullseye-security main
deb http://ftp.debian.org/debian bullseye-backports main
```

4. perform an update and upgrade to the newer packages
```shell
sudo apt-get update && sudo apt-get upgrade
```

5. Perform the full system upgrade
```bash
sudo apt full-upgrade
```
A curses dialoge will appear to ask about automatic service restarts, you may 
select the option to automatically restart services, this presented no issue to me

A CLI option appeared during unpacking, to ask about the modified /etc/sudoers file.
It is safe to keep your modified version, provided you have not done something to the
normal lines and only added new sudo declarations.

If no problems were encountered, you now have a working Debian Bullseye 
installation in WSL2

## required packages for installation

Install pre-required packages
```bash
sudo apt update
sudo apt install --no-install-recommends apt-transport-https ca-certificates curl gnupg2
```

## installing docker in WSL2 without docker dashboard/desktop
1. Configure package repository
```bash
source /etc/os-release
curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
```
2. Install Docker
```bash
sudo apt install docker-ce docker-ce-cli containerd.io
```
3. Add user to group
```bash
sudo usermod -aG docker $USER
```
4. Configure dockerd (windows/WSL2)
```bash
DOCKER_DIR=/mnt/wsl/shared-docker
mkdir -pm o=,ug=rwx "$DOCKER_DIR"
sudo chgrp docker "$DOCKER_DIR"
sudo mkdir /etc/docker
#sudo <your_text_editor> /etc/docker/daemon.json
```
5. modify docker daemon configuration
```bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
   "hosts": ["unix:///mnt/wsl/shared-docker/docker.sock"]
   # Note! Debian will also need the following line, I do not use other distros so you may still need this.
   # in the future I may include instructions for fedora
   "iptables": false
}
EOF
```

>`To always run dockerd automatically (Windows 10/WSL2)`

### modification in WSL2 only
Add the following to .bashrc or .profile (make sure “DOCKER_DISTRO” matches your distro, you can check it by running “wsl -l -q” in Powershell)
```bash
DOCKER_DISTRO="Debian"
DOCKER_DIR=/mnt/wsl/shared-docker
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]; then
   mkdir -pm o=,ug=rwx "$DOCKER_DIR"
   sudo chgrp docker "$DOCKER_DIR"
   /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi
```
---
# Installing Kubernetes

### system prep for kubernetes to run properly (linux/WSL2)
>`in WSL2 (using cmdr at least) you need to open the files and remove leading spaces after running these commands. These commands work on linux without issue (debian)`
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
  br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
EOF
```

2. Download the Google Cloud public signing key:
```bash
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```

3. Add the Kubernetes apt repository:
```bash
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

4. Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
```bash
sudo sysctl --system
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

## cri-dockerd from mirantis

cri-dockerd is a "shim" that inserts between kubernetes and docker to implement Continer runtime interface for docker containers that deviate from CRI in releases past (insert release version here)

#### `linux instructions` (.deb file)
```bash
# old
#https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.5/cri-dockerd_0.2.5.3-0.debian-buster_amd64.deb
# newer
curl https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.6/cri-dockerd_0.2.6.3-0.debian-stretch_amd64.deb
sudo dpkg -i cri-dockerd_0.2.5.3-0.debian-buster_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo systemctl start cri-docker.service cri-docker.socket
```
---
### `windows instructions`

>`on WSL2 you need to manually run cri-dockerd or create a windows file, that runs on boot, or use a command line parameter when calling WSL.exe`
* you can add `cri-dockerd` to your `~/.bashrc` and put an entry in `/etc/sudoers` for passwordless operation
```bash 
#~/.bashrc entry
nohup cri-dockerd &
```
```bash
#/etc/sudoers entry
<USERNAME> ALL = NOPASSWD: /user/bin/cri-dockerd
```
* you can call `wsl.exe` with the service name as a parameter using `{TODO: insert proper string here}`
* TODO: add instructions for the windows file necessary to boot wsl2 with service active

---
the default network plugin for `cri-dockerd` is set to `cni` on Linux. To change this, `--network-plugin=${plugin}`
can be passed in as a command line argument if invoked manually, or the systemd unit file
(`/usr/lib/systemd/system/cri-docker.service` if not enabled yet,
or `/etc/systemd/system/multi-user.target.wants/cri-docker.service` as a symlink if it is enabled) should be
edited to add this argument, followed by `systemctl daemon-reload` and restarting the service (if running)

# building cri-dockerd from source (linux)
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

