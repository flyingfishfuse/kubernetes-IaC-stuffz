#!/bin/bash
## $PROG DEPLOY.SH v1.0
## |-- BEGIN MESSAGE -- ////##################################################
## | This program is a MULTI USE SCRIPT for bootstrapping a k8s cluster
## | To use:
## | 1. Create two debian VM's, with hostnames "controller" and "worker"
## | 2. modify the variables at the top of the script
## | 
## | Run the script on the controller VM, with the -c flag
## |     deploy.sh --controller
## | 
## | It will create a kubernetes control plane and then ssh into the worker
## | and create a worker node
## | 
## | To use this on baremetal you must have debian bullseye installed on the
## | server and it must have ssh enabled and be on the same LAN
## | 
## | I STRONGLY RECCOMEND YOU USE THIS ON FRESH INSTALLATIONS OF DEBIAN
## | 
## | currently, this script requires 192.168.0.1/24 where the control
## | plane is 192.168.0.2 and workers are subsequentally sequential numbering
## | e.g. 
## |    # workers 
## |    192.168.0.3 worker1
## |    192.168.0.4 worker2
## |    192.168.0.5 worker3
## |    192.168.0.6 worker4
## | 
## | Later revisions will contain multiple control planes, this is POC for me
## | 
## | Commands:
## |   -m, --menu             Displays the menu (administration functionality)
## |   -h, --help             Displays this help and exists
## |   -v, --version          Displays output version and exits
## |   -c, --controller       Runs Control flow for controller VM (first step)
## |   -w, --worker           Runs Control flow for worker VM (second step)
## |   -l, --list_functions   Lists all available functions, manual operations
## |   -t, --test             Runs in TEST mode, writes to files in hierarchy 
## |                          of folders
## |   
## | Examples:
## |  $PROG --help > help_text.txt
## |  $PROG --controller
## |  $PROG --menu
## |  $PROG --list_functions (will show all functions in script with info)
## |  $PROG --<function name> (will run that specific named function)
## | 
## | stackoverflow.com: 
## | questions/14786984/best-way-to-parse-command-line-args-in-bash
## |-- END MESSAGE -- ////#####################################################
# behavior selector
DEBUG="true"
PROG=${0##*/}
LOG=info
die() { echo "$@" >&2; exit 2; }
# shows menu if requested
menu(){
  MENU=1
}
test(){
TEST=1
}
log_info() {
  LOG=info
}
log_quiet() {
  LOG=quiet
}
log() {
  [ $LOG = info ] && echo "$1"; return 1 ## number of args used
}
help() {
  grep "^##" "$0" | sed -e "s/^...//" -e "s/\$PROG/$PROG/g"; exit 0
}
version() {
  help | head -1
}
# Once it gets to here, if you havent used a flag, it displays the help and then exits
# run the [ test command; if it succeeds, run the help command. $# is the number of arguments
if [ $# = 0 ]; then
  help
else
  while [ $# -gt 0 ]; do
    CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" "${0}" | tr - _)
    if [ -z "$CMD" ]; then 
      exit 1; 
    fi
    shift; 
    eval "$CMD" "$@" || shift $? 2> /dev/null
    done
  fi

###############################################################################
# debugging and init vars
###############################################################################

# set debugging output for bash issues
set -x
# get name and path of script
SELF=$(realpath "$0")

###############################################################################
# IMPORTANT VARIABLES
###############################################################################
# version used at release of this script
# necessary for building cri-dockerd
# also good for creating various scripts
current_go_version="1.19.4"

# packages for functionality
# each set will need to be installed in its own step, I dont want to encounter
# any side effects of downloading them all at once, if any exist
admin_required_packages="git tmux apt-transport-https ca-certificates curl gnupg lsb-release ufw xxd wget curl netcat python3 python3-pip"
kvm_required_packages="qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker"
kubernetes_required_packages=" "
docker_required_packages=""


# sets location for backups of configs and various files
home_dir="/home/$USER"
backups_location="$home_dir/Desktop/backups"
mkdir "$backups_location"
ssh_config="/etc/ssh/sshd_config"
ssh_config_temp="/etc/ssh/sshd_config.tmp"
ssh_key_location="$home_dir/.ssh/"
ssh_authorized_key_location="/home/$USER/.ssh/authorized_keys"

###############################################################################
# NETWORK MAPPING
# HOSTNAME AND IP ADDRESSES
###############################################################################
# this must reflect the setup of your network, this gets added to hosts file

########################################
# organizationl configuration
########################################
control_plane_hostname="control"
worker_hostname="worker"

# 3 for good redundancy
number_of_controllers=3
# ip to start at 192.168.0.2 to allow for 192.168.0.1 to be router/ingress
# 192.168.0.2 controller1
# 192.168.0.3 controller2
# 192.168.0.4 controller3
# plus one for the indexing of ip ranging, plus one for the router/ingress
controller_ip_range_start=$((1 + 1))
echo "[+] starting ip address of controller nodes is 192.168.0.$controller_ip_range_start"
controller_ip_range_end=$((number_of_controllers + 1))
echo "[+] controller ip range end is 192.168.0.$controller_ip_range_end"

number_of_workers=3
# 192.168.0.5 worker1
# 192.168.0.6 worker2
# 192.168.0.7 worker3
# with three controllers, starting at 2
# it should be 3(2,3,4) + 3(5,6,7) - 3(7,6,5) == 5
# plus one for the indexing of ip ranging, plus 1 for the last controller
worker_ip_range_start=$((number_of_controllers + 2))
echo "[+] starting ip address of worker nodes is 192.168.0.$worker_ip_range_start"
worker_ip_range_end=$((number_of_controllers + number_of_workers + 1)) 
echo "[+] worker ip range end is 192.168.0.$worker_ip_range_end"
#worker_ip=$(($worker_ip_range_end-$number_of_controllers + 1))
# ip range to start worker addresses


# DEPRECATED ######## BEGIN
#
#CONTROL PLANE HOSTS FILE CONFGURATION
# the heredoc will be populated with the same number of hosts as defined in 
# number_of_workers:int
# resulting in the format: 192.168.0.x worker:int
#######################################

# todo: add number of controllers
#control_hosts_file=$(cat<<EOF
## Host addresses 
#127.0.0.1  localhost
#127.0.1.1  $control_plane_hostname
#::1        localhost ip6-localhost ip6-loopback
#ff02::1    ip6-allnodes
#ff02::2    ip6-allrouters
#EOF
#)
#
##WORKER NODE HOSTS FILE CONFGURATION
########################################
#worker_hosts_file=$(cat<<EOF
## Host addresses 
#127.0.0.1  localhost
#127.0.1.1  $worker_hostname
#::1        localhost ip6-localhost ip6-loopback
#ff02::1    ip6-allnodes
#ff02::2    ip6-allrouters
#EOF
#)
# DEPRECATED ######## END

########################################
#      Color echo
########################################
green="$(tput setaf 2)"
red=$(tput setaf 1)
yellow=$(tput setaf 3)
# prints color strings to terminal
# Argument $1 = message
# Argument $2 = color
cecho ()
{
  local default_msg="No message passed."
  # Doesn't really need to be a local variable.
  # Message is first argument OR default
  # color is second argument
  message=${1:-$default_msg}   # Defaults to default message.
  color=${2:-$black}           # Defaults to black, if not specified.
  printf "%b \n" "${color}${message}"
  #printf "%b \n" "${color}${message}"
  tput sgr0 #Reset # Reset to normal.
} 

########################################
# checks if this script is being run on baremetal
# sets VIRTUALIZED=1 if 
########################################
check_if_virt()
{
cecho "[+] checking if currently running inside of virtualbox or qemu"
# first method
if sudo dmidecode -s system-product-name | grep -q "VirtualBox"; then
VIRTUALIZED=1
fi
# second method
if sudo dmesg | grep -q "Hypervisor detected";then
VIRTUALIZED=1
fi
# third method
if hostnamectl status | grep -q "Chassis: vm" \| "Virtualization: kvm"; then
VIRTUALIZED=1
fi
if systemd-detect-virt | grep -q "oracle " \| "KVM"; then
VIRTUALIZED=1
fi
if [ $VIRTUALIZED == 1 ] ; then
cecho "[+] Script is running inside a VM"
fi
}
check_if_virt

###############################################################################
# NETWORKING CONFIGURATION
###############################################################################

#######################################
# Appends the host entries to the 
# given hostname, use this after copying keys
# to worker VMs
# param1 : worker hostname to ssh to
# param2 : hostfile addendum heredoc for "sudo tee /etc/hosts"
# Example : append_to_vm_hostfile "worker1" "$new_hosts_addendum"
########################################
append_to_vm_hostfile()
{
# we want the provided heredoc to expand into this heredoc
# so it can be sent as is
ssh "$USER"@"$1" <<EOF | sudo tee /etc/hosts
$2
EOF

# prevent changes to dns configuration
ssh $USER@"$1" <<EOF
sudo chattr +i /etc/hosts
EOF
}
########################################
# sets hosts file
# param1 : hostname
# param2 : $hosts_file_addendum
########################################
both_set_hosts(){
# create the hosts file from supplied parameters at top of script
new_hosts_file=$(controller_create_hosts_file "$2")
# place in /etc for NATLAN access
append_to_vm_hostfile "$1" "$new_hosts_file"

}

###############################################
# returns a heredoc of an addendum to the 
# controller host file to apply to /etc/hosts 
# on control plane.
# We are appending to the original in 
# /etc/hosts later in the code
# the controllers must be able to see everything
# so the workers and controllers are routable
#
# param1: hostname to apply file to
###############################################
controller_create_hosts_file()
{
# to be added to controller hosts file
hosts_addendum=$(cat <<EOF
$(for i in $(seq $controller_ip_range_start); do
  echo "192.168.0.$i controller$i"
done )
# workers
$(for i in $(seq $worker_ip_range_start); do
  echo "192.168.0.$i worker$i"
done )
EOF
)
# append the workers hosts entries to the controller's basic hosts file
# deprecated: I am appending to the hosts file on the VMs directly now
# as opposed to creating a whole new hosts file and replacing the original
#new_hosts_heredoc=append_heredocs "$1" "$worker_hosts_addendum"
#echo "$worker_hosts_addendum"
#TODO: ask for verification

echo "===================================="
cecho "[+] New hosts file addendum :" $green
cecho "[+] Host being modified : $1" $green
echo "$hosts_addendum"
echo "===================================="

# ssh to vm and apply new /etc/hosts configuration
# ONLY IF USING LINUX BAREMETAL HOST OR LINUX MASTER VM
# DEVELOPMENT IS DONE ON WINDOWS CURRENTLY BECAUSE LINUX
# CANT HANDLE TWO DISPLAYS ON TWO SEPERATE NVIDIA GPUS WITH A 
# WACOM TABLET AND I DONT FEEL LIKE RUNNING THREE VMS

if [ $VIRTUALIZED == "true" ]; then
# apply to control vm, while running script FROM that specific VM
cat << EOF | sudo tee -a /etc/hosts
$hosts_addendum
EOF
else
# apply to remote host over ssh if not being run from
# a vm
# deprecated
#both_set_hosts "$1" "$hosts_addendum"
append_to_vm_hostfile "$1" "$new_hosts_file"
fi
}

###############################################################################
# returns a heredoc of the worker host file
# to apply to /etc/hosts on worker node
# param1 : worker hostname
# they must be able to see the controller 
# but not each other
# only the controllers are visible
# that is why there are two seperate functions
#######################################
worker_create_hosts_file()
{
hosts_addendum=$(cat <<EOF
$(
for i in $(seq $number_of_controllers); do
  echo "192.168.0.(($i+$controller_ip_range_start)) $control_plane_hostname$i"
done
)
EOF
)
# show results for verification
#TODO: ask for verification
echo "===================================="
cecho "[+] New hosts file addendum " $green
cecho "[+] Host being modified : $1" $green
echo "$hosts_addendum"
echo "===================================="
# ssh to vm and apply new /etc/hosts configuration
append_to_vm_hostfile "$1" "$hosts_addendum"

}

prepare_for_KVM()
{
echo "wat!?!?! this aint ready yo, baka senpai pleasssseeeeee!!"

# determine if intel or AMD
cat /proc/cpuinfo | grep kvm\|svm

# determine if modules loaded
lsmod | grep kvm

# for intel
# load modules if unloaded
modprobe kvm_intel

# enable libvirtd daemon
systemctl enable --now libvirtd
}

create_VM()
{
# once libvirtd service is started, we can use the virt-install command to setup
# The following linux command must be executed as root 
# to run as normal user you must be a member of the kvm group:
VM_name="linuxconfig-vm"
install_media="/home/$USER/Downloads/debian-9.0.0-amd64-netinst.iso"
memory=1024
vcpus=2
disk_size=5
os_variant="debian8"

virt-install --name=$VM_name \
--vcpus=$vcpus \
--memory=$memory \
--cdrom=$install_media \
--disk size=$disk_size \
--os-variant=$os_variant

}

########################################
# adds internet nameservers
#param1: hostname to apply changes to
########################################
set_dns(){
#cat <<EOF | sudo tee /etc/resolv.conf
sudo ssh $USER@$1 <<EOF | sudo tee /etc/resolv.conf
domain home
search home
nameserver 192.168.254.254

nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
# prevent changes to dns configuration
sudo chattr +i /etc/resolv.conf
}


###############################################################################
# remove when tests complete
###############################################################################
control_plane_hostname="control"
worker_hostname="worker"

number_of_controllers=3
controller_ip_range_start=$((1 + 1))
echo "[+] starting ip address of controller nodes is 192.168.0.$controller_ip_range_start"
controller_ip_range_end=$((number_of_controllers + 1))
echo "[+] controller ip range end is 192.168.0.$controller_ip_range_end"

number_of_workers=3
worker_ip_range_start=$((number_of_controllers + 2))
echo "[+] starting ip address of worker nodes is 192.168.0.$worker_ip_range_start"
worker_ip_range_end=$((number_of_controllers + number_of_workers + 1)) 
echo "[+] worker ip range end is 192.168.0.$worker_ip_range_end"


for i in $(seq $number_of_controllers)
do 
  # make sequential hostname
  hostname="${control_plane_hostname}${i}"
  echo $hostname
  # keep this when done testing
  #control_set_hosts $hostname
  # create line entry
  hosts_addendum=$(cat <<EOF
  $(for h in $(seq $controller_ip_range_start); do
    echo "192.168.0.$h controller$h" 
  done )
  # workers
  $(for h in $(seq $worker_ip_range_start); do
    echo "192.168.0.$h worker$h"
  done )
EOF
  )
  echo "===================================="
  cecho "[+] New hosts file addendum :" $green
  cecho "[+] Host being modified : $1" $green
  echo "$hosts_addendum"
  echo "===================================="
done
###############################################################################
# remove when tests complete
###############################################################################

########################################
#sets up network configuration to establish access
control_establish_network(){
# set dns on control planes
for i in $(seq $number_of_controllers)
do 
  hostname="${control_plane_hostname}${i}"
  echo $hostname
  # ssh to indicated hostname and apply /etc/hosts heredoc addundum
  # control_set_hosts $hostname
  # ssh to indicated hostname and apply resove.conf heredoc
  # set_dns $hostname
done

}
########################################
#sets up network configuration to establish access
# both_set_dns
# worker_set_hosts
worker_establish_network()
{
for i in $(seq $number_of_controllers)
do 
  hostname="${control_plane_hostname}${i}"
  echo $hostname
  # ssh to indicated hostname and apply /etc/hosts heredoc addundum
  # worker_set_hosts $hostname
  # ssh to indicated hostname and apply resove.conf heredoc
  # set_dns $hostname
done
}

# stop sleep modes
both_stop_sleep()
{
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
}

###############################################################################
# SSH
###############################################################################

#######################################
#secures SSH access and backs up original config
##########################################
both_setup_ssh(){
# backup configs
sudo cp $ssh_config "$backups_location/sshd_config.original"
sudo chmod a-w "$backups_location/sshd_config.original"
# locks original to allow a successful rollback if absolutely necessary
# while internet is down
sudo chattr +i "$backups_location/sshd_config.original"
##########################################
# create ssh config
#######################################
cat <<EOF | sudo tee $ssh_config_temp
Include /etc/ssh/sshd_config.d/*.conf
# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
# override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server
PrintMotd no
# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no
# the important stuff
Protocol2
IgnoreRhosts yes
HostbasedAuthentication no
PermitEmptyPasswords no
X11Forwarding no
MaxAuthTries 5
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
ClientAliveInterval 900
ClientAliveCountMax 0
UsePAM yes
EOF
#######################################
# copy temp file to main file, overwriting original
#######################################
sudo cp $ssh_config_temp $ssh_config
# restart ssh service
sudo systemctl enable ssh --now
sudo systemctl start sshd.service
# secondary method, using sed, in place changes
#sed -i '/#Protocol2/c\Protocol2' $ssh_config
#sed -i '/#IgnoreRhosts/c\IgnoreRhosts yes' $ssh_config
#sed -i '/#HostbasedAuthentication/c\HostbasedAuthentication no' $ssh_config
#sed -i '/#PermitEmptyPasswords/c\PermitEmptyPasswords no' $ssh_config
#sed -i '/#X11Forwarding/c\' $ssh_config
#sed -i '/#MaxAuthTries/c\' $ssh_config
#sed -i '/#Ciphers aes128-ctr,aes192-ctr,aes256-ctr/c\' $ssh_config
#sed -i '/ClientAliveInterval/c\ClientAliveInterval 900' $ssh_config
#sed -i '/ClientAliveCountMax/c\ClientAliveCountMax 0' $ssh_config
#sed -i '/UsePAM/c\UsePAM yes' $ssh_config
# SPARE SLOT
#sed -i '//c\' $ssh_config
}

# The file with the ".pub" extension contains the public portion of the key.
# when copying RSA keys to remote servers you wish to use passwordless 
# authentication with, you must copy the public key with the .pub extension
# 
# The corresponding file without the ".pub" extension contains the private 
# part of the key. When you run an ssh client to connect to a remote server, 
# you have to provide the private key file to the ssh client. The remote
# server then authenticates that against the public key.


#######################################
# creates an RSA key pair for ssh and other uses
#######################################
control_generate_key_pair()
{
cecho "[+] Generating RSA key-pair for SSH" "$green"
# BASH only
ssh-keygen -q -t rsa -N '' <<< $'\ny' >/dev/null 2>&1
# portable, not working
#ssh-keygen -q -t rsa -N '' -f "$ssh_key_location" <<<y >/dev/null 2>&1
cecho "[+] New Key Generated at $ssh_key_location" $green
cecho "[+] COPYING KEY TO BACKUP $backups_location/ssh/" $green
cp -a -v "$ssh_key_location" "$backups_location/ssh/"
}
#######################################
# creates and sends an RSA key to the worker host
# adding it to the workers authorized keys
#######################################
control_authorize_ssh_key_to_worker()
{
# use the above function to generate an RSA keypair
generate_key_pair
# copy id to remote server/worker
cecho "[+]Copying Public RSA key to worker VM" "$green"
# copies public key to remote
# -i option allows you to specify which public key to send
# the default key is "home/$USER/.ssh/id_rsa.pub"
ssh-copy-id -i "$ssh_key_location/id_rsa.pub" "$USER@worker"
# TODO: use this if ssh-copy-id is not available
#cat /home/$USER/.ssh/id_rsa.pub | ssh remote_username@server_ip_address "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

}

#######################################
# function to be run on worker node
#######################################
worker_prepare_ssh()
{
cecho "[+] Preparing ssh access on worker node" "$green" 
mkdir -p "/home/$USER/.ssh"
# create file to hold allowed keys
touch "$ssh_authorized_key_location"
# set permissions
chmod 700 "/home/$USER/.ssh" && chmod 600 "$ssh_authorized_key_location"
# set owner
chown -R "$USER":"$USER" "/home/$USER/.ssh"
# copy key to authorized keys file
#cat "$ssh_key_location/id_rsa.pub" >> "$ssh_authorized_key_location"
}

#######################################
# function to be run on worker node
# removes authorized keys and generated 
# keys
#######################################
clean_ssh_keys()
{
ssh "$USER"@worker << 'EOF'
rm -rf /home/$USER/.ssh/*
ls -la /home/$USER/.ssh/
exit
EOF
}
###############################################################################
#   installtion of tooling for cloud operations
###############################################################################

install_golang_single_user(){
# official instructions demand removal of previous versions and older installs
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.5.linux-amd64.tar.gz
curl -fsSL -o "go-$current_go_version.tar.gz" "https://golang.org/dl/go$current_go_version.linux-amd64.tar.gz"
sudo tar -zxvf go1.17.linux-amd64.tar.gz -C /usr/local/
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee -a "/home/$USER/.profile"
source "/home/$USER/.profile"
}

#requires sudo
# specifically for debian
both_install_docker_debian()
{
  cecho "[+] Installing Docker" "$yellow"
  sudo apt-get remove docker docker-engine docker.io containerd runc
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  sudo groupadd docker
  #sudo gpasswd -a pi docker
  sudo usermod -aG docker "${USER}"
  sudo systemctl enable docker
  #docker run hello-world
  sudo apt-get install libffi-dev libssl-dev
  sudo apt-get install -y python python-pip
  sudo pip install docker-compose
  #docker-compose build
}

# installs docker compatibility layer
# allows usage of docker for more people to learn
both_install_cri_dockerd()
{
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd || cecho "[-] Failed to clone golang from github" && return
mkdir bin
go get && go build -o bin/cri-dockerd
sudo mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
}

# runs the following functions
# both_install_docker_debian
# install_golang_single_user
# both_install_cri_dockerd
both_install_tooling()
{
# perform an install of all required packages
sudo apt install -y "$admin_required_packages $kubernetes_required_packages $kvm_required_packages"


# the container runtime
both_install_docker_debian
# needed for building cri-dockerd from source
install_golang_single_user
# the container runtime interface
both_install_cri_dockerd

sudo sysctl --system
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl 

#echo 'source <(kubectl completion bash)' >>~/.bashrc
#source <(kubectl completion bash)
}

# preps system for running kubernetes with nsenter
prepare_system_for_kubernetes()
{
# only for kctf
#umask a+rx
#cat <<EOF | sudo tee -a /etc/sysctl.d/00-local-userns.conf
#kernel.unprivileged_userns_clone=1
#EOF

#You *may* need to run the following command to allow systemd to access the `resolved` service. 
#On a new Debian install it was necesary
sudo ln -sf /lib/systemd/system/systemd-resolved.service /etc/systemd/system/dbus-org.freedesktop.resolve1.service

# kubernetes cannot override IPTables without the following
# necessary modules, overlay and bridge netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward                 = 1
EOF

# enact changes
sudo service procps restart
sudo modprobe overlay
sudo modprobe br_netfilter
# Apply sysctl params without reboot
sudo sysctl --system 

#allow delegation of other controllers such as cpu, cpuset, and io
sudo mkdir -p /etc/systemd/system/user@.service.d && \
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload
}
###############################################################################
# initialize the cluster with calico CIDR
control_init_cluster()
{
# turn off swap, kubernetes seems not to work with it on?
sudo swapoff -a

# pre pull container images for later setup, allows uninitiated checks on configuration
#kubeadm config images pull

# initiate cluster with flannel CNI using cri-dockerd
#sudo kubeadm init --cri-socket=unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16
# initiate cluster with calico CNI using cri-dockerd
sudo kubeadm init \
--cri-socket=unix:///var/run/cri-dockerd.sock \
--pod-network-cidr=192.168.1.0/16 \
--apiserver-advertise-address=10.0.2.15 \
--control-plane-endpoint devbox:6443

#configure kubernetes for usage
mkdir -p "$HOME/.kube" && \
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config" && \
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
}
# or do this if you are root user, or both, doesnt matter for most usages
# if doing both make sure you copy config to config on ANY change
# and keep track of things
#export KUBECONFIG=/etc/kubernetes/admin.conf

# create networking overlay
control_init_network_layer()
{
# flannel
#kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
#calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml
}
# join worker to cluster, this must be run on all nodes (containers or VM) that
# will be performing work as a worker in the cluster

# this DOES NOT need to be run on the master node... that node is already part of the cluster!
# this changes every time you reset and run kubeadm init, dont lose the token!
#kubeadm join 10.0.2.15:6443 --token w3zu66.j350sxheyita8bcx \
#	--discovery-token-ca-cert-hash sha256:d785d8cb80068f8031cede03fc91df5f0870debc3264f9d9197821e3a60cbba6 

control_apply_taint()
{
# instead, run THIS command, but ONLY if you are planning to run workloads on the control plane!
kubectl taint nodes --all node-role.kubernetes.io/control-plane- node-role.kubernetes.io/master-
}

control_install_dashboard()
{
# install kubernetes dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
# set proxy to allow access to dashboard
kubectl proxy &
}

control_create_admin_service_account()
{
# create admin service account config
cat <<EOF | sudo tee ./create_service_account.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# apply admin service account config
kubectl apply -f ./create_service_account.yaml

# extract token for browser input
kubectl -n kubernetes-dashboard create token admin-user > ./token.txt
echo "admin token for dashbord has been created in ./token.txt, put this into the dashboard login portal"
}

# this opens a browser to the dashboard, only useful on the master which has fluxbox running for GUI tooling
control_open_dashboard()
{
firefox-esr http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
}

# performs a reset of the entire cluster
control_reset_cluster(){
# reset cluster
sudo kubeadm reset
# remove lingering configs
sudo rm -rf ~/.kube/* /etc/kubernetes/*
# reset iptables changes
sudo /usr/sbin/iptables -F
sudo /usr/sbin/iptables -X
sudo /usr/sbin/iptables -t nat -F
sudo /usr/sbin/iptables -t nat -X
sudo /usr/sbin/iptables -t raw -F
sudo /usr/sbin/iptables -t raw -X
sudo /usr/sbin/iptables -t mangle -F
sudo /usr/sbin/iptables -t mangle -X
}

worker_install_caldera(){
  unset CDPATH
  cd "$backups_location" ||  echo "Failed to cd to backups directory" && return
  git clone https://github.com/mitre/caldera.git --recursive --branch master
  cd caldera ||  echo "Failed to cd to caldera directory" && return
  pip3 install -r requirements.txt
}

worker_start_caldera_server_host(){
  cd "$backups_location/bin/caldera/" || echo "Failed to cd to caldera directory" && return
  python3 server.py --insecure
}

worker_start_caldera_docker(){
# Run the image. Change port forwarding configuration as desired.
docker run -p 8888:8888 caldera:latest
}

# removes all docker containers
purge_docker()
{
sudo docker container rm "$(sudo docker container list -a -q)"
sudo docker image rm "$(sudo docker image list -a -q)"
}

###############################################################################
# transfer functionality, copies this script to worker VM and runs it with 
# worker control flow
###############################################################################

#######################################
# sends THIS file to the worker node
# using the authorized RSA key
#######################################
control_send_script_to_worker()
{
cecho "[+] Sending deploy.sh to worker VM" "$green"
scp -i "$ssh_key_location/id_rsa" "$SELF" "$USER@worker":"/home/$USER/deploy.sh"
}

control_run_deploy_script_on_worker()
{
# sources file, runs the test echo
#ssh  "$USER"@worker "$(declare -f test_echo); test_echo"
ssh "$USER"@worker << 'EOF'
source "/home/$USER/test.sh"
test_echo
EOF
}
###############################################################################
# CODE TO RUN ON MASTER ONLY
control_task()
{
# prepare system for unsupervised operation
both_stop_sleep
# necessary to ensure working internet
control_establish_network
# setup SSH for moving from control to worker
both_setup_ssh

# install packages
both_install_tooling

# create the cluster and initialize networking
prepare_system_for_kubernetes
control_init_cluster
control_init_network_layer

# init dashboard
control_install_dashboard
control_create_admin_service_account

# prepare worker loads to run on master
#control_apply_taint

# establishes an ssh connection to the worker VM
# and copies this script to it, then runs the set of commands
# outlined below
control_generate_key_pair
control_authorize_ssh_key_to_worker
control_send_script_to_worker
control_run_deploy_script

}

###############################################################################
# code to run on worker nodes only!
worker_task()
{
# prepare system for unsupervised operation
both_stop_sleep
# necessary to ensure working internet
worker_establish_network
both_setup_ssh

# install packages
both_install_tooling
both_install_docker_debian
both_install_cri_dockerd

# create the cluster and initialize networking
prepare_system_for_kubernetes

worker_install_caldera
worker_prepare_ssh

}

###############################################################################
show_menus()
{
	#clear
  cecho "# |-- BEGIN MESSAGE -- ////################################################## " "$green"
  cecho "# |   OPTIONS IN RED ARE EITHER NOT IMPLEMENTED YET OR OUTRIGHT DANGEROUS "
  cecho "# | 1> Install Prerequisites " "$green"
  cecho "# | 2> Update Containers (docker-compose build) " "$green"
  cecho "# | 4> Clean Container Cluster (WARNING: Resets Volumes, Networks and Containers) " "$yellow"
  cecho "# | 5> REFRESH Container Cluster (WARNING: RESETS EVERYTHING) " "$red"
  cecho "# | 13> Quit Program " "$red"
  cecho "# |-- END MESSAGE -- ////##################################################### " "$green"

  PS3="Choose your doom:"
  select option in install update clean reset quit
  do
	  case $option in
    # installs prereqs
      install) 
	  		installprerequisites;;
    # updates all docker containers
      update)
        update_containers;;
      # does a kubeadm reset of all namespaces
      # also removes kubeconfig and manifests
      clean)
        control_reset_cluster;;
      # exit TUI application
      quit)
        break;;
      esac
  done
}
#if "$MENU" '==' 1 ;then
# run the menu if no arguments have been called
# this also throws up the help text to walk user through operation
if [ "$MENU" == 1 ]; then
  while true
  do
    show_menus
  done
fi


#TODO: build the test
# write to files in hierarchy representing the network structure
if [ $TEST == 1 ]; then
echo "testing"
fi
