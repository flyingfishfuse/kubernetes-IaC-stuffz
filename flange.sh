## A flange is an object that joins two objects at flat faces
#!/usr/bin/bash
## $PROG SANDBOXY.SH v1.0
## |-- BEGIN MESSAGE -- ////##################################################
## | This program is a MULTI USE SCRIPT for a new sysadmin system
## |    this program contains a self archiving feature that base64 encodes and
## |    compresses a folder and appends it as data to the end of this script
## |    yes thats right, it is a text based installer
## | 
## | Commands:
## |   -m, --menu             Displays the menu
## |   -h, --help             Displays this help and exists
## |   -v, --version          Displays output version and exits
## | 
## | Examples:
## |  $PROG --help myscrip-simple.sh > help_text.txt
## |  $PROG --menu myscrip-full.sh
## | 
## | stackoverflow.com: 
## | questions/14786984/best-way-to-parse-command-line-args-in-bash
## |-- END MESSAGE -- ////#####################################################

PROG=${0##*/}
LOG=info
die() { echo "$@" >&2; exit 2; }
menu(){
  MENU=1
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

# While there are arguments to parse:
# WHILE number of arguments passed to script is greater than 0 
# for every argument passed to the script DO
#while [ $# -gt 0 ]; do

#  CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" ${0} | tr - _)
#         assign results of `grep | tr` to CMD
#             searches through THIS file :
# 
#          grep -m 1, 
#            stop after first occurance
#
#         -Po, perl regex 
#             Print only the matched (non-empty) parts of a matching line
#            with each such part on a separate output line.

#         ^## *$1, 
#            MATCHES all the "##" until the END of the "-letter" argument
#             
#         "|" 
#            MATCHES one OR the other
#
#           --\K[^= ]* 
#            MATCHES all the "--words" arguments
#
#           \K 
#            "resets the line position"
#            With -o it will 
#            print the result from \K to the end that matched the regex. 
#             It's often used together grep -Po 'blabla\Kblabla'
#             For example `echo abcde | grep -P 'ab\K..'` will print "de"

#           tr - _ 
#             substitutes all - for _
  while [ $# -gt 0 ]; do
    CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" "${0}" | tr - _)
    if [ -z "$CMD" ]; then 
      exit 1; 
    fi
    shift; 
    eval "$CMD" "$@" || shift $? 2> /dev/null
    done
  fi
# original:
#[ $# = 0 ] && help
#while [ $# -gt 0 ]; do
#  CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" log.sh | sed -e "s/-/_/g")
#  if [ -z "$CMD" ]; then echo "ERROR: Command '$1' not supported"; exit 1; fi
#  shift; eval "$CMD" $@ || shift $? 2> /dev/null
#done
#=========================================================
#            Colorization stuff
#=========================================================
black='\E[30;47m'
#red='\E[31;47m'
#green='\E[32;47m'
#yellow='\E[33;47m'
#blue='\E[34;47m'
#magenta='\E[35;47m'
#cyan='\E[36;47m'
#white='\E[37;47m'
#magenta=$(tput setaf 5)
#blue=$(tput setaf 4)
#cyan=$(tput setaf 6)
green="$(tput setaf 2)"
#purple=$(tput setaf 5)
red=$(tput setaf 1)
#white=$(tput setaf 7)
yellow=$(tput setaf 3)

cecho ()
{
  # Argument $1 = message
  # Argument $2 = color
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
###############################################################################
#       WAT
###############################################################################
#
# SELF ARCHIVING FEATURES
#

# returns an int representing seconds since first epoch
# The 'date' command provides the option to display the time in seconds since 
# Epoch(1970-01-01 00:00:00 UTC).  
# Use the FORMAT specifier '%s' to display the value.
getepochseconds=$(date '+%s')
# first arg is tarfile name, to allow for multiple files
readselfarchive()
{
  cecho "[+] EXTRACTING: ${1}"
  # line number where payload starts
  PAYLOAD_START=$(awk "/^==${TOKEN}==${1}==START==/ { print NR + 1; exit 0; }" "${SELF}") #$0)
  PAYLOAD_END=$(awk "/^==${TOKEN}==${1}==END==/ { print NR + 1; exit 0; }" "${SELF}" ) #$0)
  #tail will read and discard the first X-1 lines, 
  #then read and print the following lines. head will read and print the requested 
  #number of lines, then exit. When head exits, tail receives a SIGPIPE
  #if < "${SELF}" tail -n "+${PAYLOAD_START}" | head -n "$(("${PAYLOAD_END}"-"${PAYLOAD_START}"+1))" | tar -zpvx -C "${INSTALLDIR}""${1}"; then
  if < "${SELF}" tail -n "+${PAYLOAD_START}" | head -n "$(("${PAYLOAD_END}"-"${PAYLOAD_START}"+1))" | tar -zpvx -C ./sandboxy ; then
    cecho "[+] SUCCESS! You should now be able to perform the next step!"
    cecho "[+] Modify the .env file and make any changes you want then build the environment and run it"
  else
    cecho "[-] FAILED to Extract Archive Labeled ${1}"
    exit 1
  fi
}

appendtoselfasbase64()
{
  currentdatetime="${getepochseconds}"
  cecho "[+] APPENDING: ${currentdatetime}" "$yellow"
  # add token with filename for identifier
  printf "%s" "==${TOKEN}==${currentdatetime}==START==" >> "$SELF"
  # add the contents of the current directory
  # minus the start.sh and lib.sh scripts
  # " - " is the "dummy" or "pipe to stdout" operator for tar 
  if tar --exclude="${SELF}" --exclude="${EXTRANAME}" -czvf - ./* | base64 >> "$SELF"; then
    cecho "[+] Project packed into archive!"
    # seal with an ending token
  else
    cecho "[-] Failed to tar directory into archive"
    exit 1
  fi
  cecho "[+] Sealing archive"
  if printf "%s" "==${TOKEN}==${currentdatetime}==END==" >> "$SELF"; then
    cecho "[+] Sealed! Modifications saved as ${currentdatetime}"
    exit
  else
    cecho "[-] Failed to seal archive, this shouldn't happen, the file might have dissappeared"
    exit 1
  fi
}
appenddatafolder()
{
  currentdatetime="${getepochseconds}"
  cecho "[+] APPENDING: ${currentdatetime}" "$yellow"
  # add token with filename for identifier
  printf "%s" "==${TOKEN}==${currentdatetime}==START==" >> "$SELF"
  # add the contents of the current directory
  # minus the start.sh and lib.sh scripts
  # " - " is the "dummy" or "pipe to stdout" operator for tar 
  #from above projectroot
  unset CDPATH
  cd "$DIR" || { printf "%s" $! && exit ;}
  cd ../
  if sudo tar -czvf - ./sandboxy/data | base64 >> "$SELF"; then
    cecho "[+] Project packed into archive!"  "$green"
    # seal with an ending token
  else
    cecho "[-] Failed to tar directory into archive" "$red"
    exit 1
  fi
  cecho "[+] Sealing archive" "$green"
  if printf "%s" "==${TOKEN}==${currentdatetime}==END==" >> "$SELF"; then
    cecho "[+] Sealed! Modifications saved as ${currentdatetime}"
    exit
  else
    cecho "[-] Failed to seal archive, this shouldn't happen, the file might have dissappeared"
    exit 1
  fi
  unset CDPATH
  cd "$DIR" || { printf "%s" "could not change directory to " && exit ;}
  exit 1
}
# First arg: section
#   ==${TOKEN}START==${1}==
#       DATA AS BASE64
#   ==${TOKEN}END==${1}==
grabsectionfromself()
{
  STARTFLAG="false"
  while read LINE; do
      if [ "$STARTFLAG" == "true" ]; then
              if [ "$LINE" == "==${TOKEN}==${1}==END==" ];then
                      exit
              else
                printf "%s" $LINE
              fi
      elif [ "$LINE" == "==${TOKEN}==${1}==START==" ]; then
              STARTFLAG="true"
              continue
      fi
  # this sends the descriptor to the while loop
  # it gets fed from the bottom
  done < "$SELF"
  exit
}
#yes this needs cleaning
listappendedsections()
{
  grep "${TOKEN}" < "${SELF}"
  exit
}
# first arg: filename or string data
asktoappend()
{
  while true; do
    cecho "[!] APPENDING ARCHIVE!" "$red"
    cecho "[!] Do you wish to continue? (backspace and press y then hit enter to accept)" "$red"
    cecho "[?]" "$red"; cecho "y/N ?" "$yellow"
    read -e -i "n" yesno
    cecho "[?] Are You Sure? (y/N) (backspace and press y then hit enter to accept)" "$yellow"
    read -e -i "n" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    case $yesno in
        [Yy]* ) appendtoselfasbase64;;
        [Nn]* ) exit;;
        * ) cecho "Please answer yes/y or no/n." "$red";;
    esac
  done
}
askforappendfile()
{
  while true; do
    cecho "[!] This Action will compress the current directory's contents into an archive" "$red"
    cecho "[!] Do you wish to continue? (backspace and press y then hit enter to accept)" "$red"
    read -e -i "n" yesno
    cecho "[?] Are You Sure? (y/N) (backspace and press y then hit enter to accept)" "$yellow"
    read -e -i "n" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    case $yesno in
        [Yy]* ) asktoappend;;
        [Nn]* ) exit;;
        * ) cecho "Please answer yes/y or no/n." "$red";;
    esac
  done
}
asktorecall()
{
  while true; do
    cecho "[!] RECALLING : ${1}" "$red"
    cecho "[!] Do you wish to continue? (backspace and press y then hit enter to accept)" "$red"
    cecho "[?]" "$red"; cecho "y/N ?" "$yellow"
    read -e -i "n" yesno
    cecho "[?] Are You Sure? (y/N) (backspace and press y then hit enter to accept)" "$yellow"
    read -e -i "n" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    case $yesno in
        [Yy]* ) grabsectionfromself "${1}";;
        [Nn]* ) exit;;
        * ) cecho "Please answer yes/y or no/n." "$red";;
    esac
  done
}
askforrecallfile()
{
  listappendedsections
  while true; do
    cecho "[!] Please Input the label you wish to retrieve" "$red"
    read -e -i "n" archivelabel
    cecho "[?] Are You Sure? (y/N)" "$yellow"
    read -e -i "n" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    case $archivelabel in
        [Yy]* ) asktorecall "${archivelabel}";;
        [Nn]* ) exit;;
        * ) cecho "Please answer yes or no." "$red";;
    esac
  done
}

# runs commands displaying shell output
# commands must be mostly simple unless you wanna debug forever
runcommand()
{
  #cmd=${1}
  runcmd=$(eval $1)
  if printf "%b\n" "$runcmd"; then
    return
  else
    printf "%s : %s \n" "[-] Failed to run command" "$cmd"
  fi
}


###############################################################################
#       DOCKER STUFF
###############################################################################
# required for nsjail, kubernetes
# run this before running 
systemparams()
{
    umask a+rx
    echo 'kernel.unprivileged_userns_clone=1' | sudo tee -a /etc/sysctl.d/00-local-userns.conf
    sudo service procps restart'
  
    sudo modprobe br_netfilter'
  
}
# use this if adding/removing from configs for containers
composebuild()
{
  #set -ev
  if docker-compose config ;then
    cmd="docker-compose -f ${PROJECTFILE} build"
  
  else
    printf "[-] Compose file failed to validate, stopping operation"
  fi
}
# provide filename of composefile.yaml 
composerun()
{
  docker-compose -f "${PROJECTFILE}" up
}
composestop()
{
  docker-compose -f "${PROJECTFILE}" down
}
startproject()
{
  composebuild
  composerun
}
#FULL SYSTEM PURGE
dockerpurge()
{
  docker system prune --force --all

}
#docker selective pruning
dockerprune()
{
  cecho "[+] pruning everything" "${yellow}"
  cmd="docker-compose -f '${PROJECTFILENAME}' down"
  docker network prune -f
  docker container prune -f
  docker volume prune -f

}
dockersoftrefresh()
{
  dockerprune && composebuild
}
dockerhardreset()
{
  dockerpurge && composebuild
}

###############################################################################
#       Docker via Kubernetes
###############################################################################


###############################################################################
#       INSTALLERS
###############################################################################
newsystem_setup()
{
sudo apt install python3 tmux git bpython fluxbox micro vim bash-completion wget

}
install_everything(){
newsystem_setup
installapt

}
## INSTALLER FUNCTIONS
# installs for debian amd64
installapt()
{
  #packages=("python3 python3-pip git tmux apt-transport-https ca-certificates curl gnupg lsb-release ufw xxd wget curl netcat")
  packages="python3 python3-pip git tmux apt-transport-https ca-certificates curl gnupg lsb-release ufw xxd wget curl netcat"
  #for item in "$packages";
  #do
  cmd="sudo apt-get install -y ${packages}"
  runcommand "$cmd"
  # done;
}

install_golang_single_user(){
# official instructions demand removal of previous versions and older installs
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.5.linux-amd64.tar.gz
wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
sudo tar -zxvf go1.17.linux-amd64.tar.gz -C /usr/local/
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee -a $HOME/.profile
source $HOME/.profile
}
install_caldera(){
  git clone https://github.com/mitre/caldera.git --recursive --branch master
  cd caldera
  pip3 install -r requirements.txt
}
start_caldera_server_host(){
  cd $PROJECTROOT/bin/caldera/
  python3 server.py --insecure
}
start_caldera_docker(){
# Run the image. Change port forwarding configuration as desired.
docker run -p 8888:8888 caldera:latest
}

install_cri_dockerd(){
  # Run these commands as root
###Install GO###
#wget https://storage.googleapis.com/golang/getgo/installer_linux
#chmod +x ./installer_linux
#./installer_linux
#source ~/.bash_profile

git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
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
#requires sudo
# specifically for debian
installdockerdebian()
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

installdockercompose()
{
  cecho "[+] Installing docker-compose version: $DOCKER_COMPOSE_VERSION" "$green" 
  if [ -z "$(sudo -l 2>/dev/null)" ]; then
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
    chmod +x docker-compose
    mv docker-compose /usr/local/bin
  else
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
    sudo chmod +x docker-compose
    sudo mv docker-compose /usr/local/bin
  fi
}
#TODO: add falback to non-root install
# chmod +x kubectl
# mkdir -p ~/.local/bin/kubectl
# mv ./kubectl ~/.local/bin/kubectl
# and then add ~/.local/bin/kubectl to $PATH
setupforkubernetes()
{
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
}

configure_c_groups_kubernetes(){
cat <<EOF | sudo tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF
# disable disabled things
sed -i 's/disabled_plugins = ["cri"]/#disabled_plugins = ["cri"]/' /etc/containerd/config.toml

}

build_install_cri_docker_d(){
git clone https://github.com/Mirantis/cri-dockerd.git
mkdir bin
VERSION=$((git describe --abbrev=0 --tags | sed -e 's/v//') || echo $(cat VERSION)-$(git log -1 --pretty='%h')) PRERELEASE=$(grep -q dev <<< "${VERSION}" && echo "pre" || echo "") REVISION=$(git log -1 --pretty='%h')
go get && go build -ldflags="-X github.com/Mirantis/cri-dockerd/version.Version='$VERSION}' -X github.com/Mirantis/cri-dockerd/version.PreRelease='$PRERELEASE' -X github.com/Mirantis/cri-dockerd/version.BuildTime='$BUILD_DATE' -X github.com/Mirantis/cri-dockerd/version.GitCommit='$REVISION'" -o cri-dockerd
}

installkubernetes()
{
  install_golang_single_user

  #kubectl
  if curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; then
    cecho "[+] kubectl downloaded" "$green" 
  else
    cecho "[-] failed to download, exiting" "$yellow"
    exit 1
  fi
  #validate binary
  curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  if echo "$(<kubectl.sha256) kubectl" | sha256sum --check | grep "OK"; then
    cecho "[+] Kubectl binary validated" "$green" 
  else
    cecho "[-] Vailed to validate binary, removing downloaded file and exiting" "$red"
    rm -rf ./kubectl 
    rm -rf ./kubectl.sha256
    exit 1
  fi
  
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  if runcommand cmd; then
    cecho "[+] Kubernetes Installed to /usr/local/bin/kubectl"
  else
    cecho "[-] Failed to install Kubernetes to /usr/local/bin/kubectl! Exiting!"
    exit 1
  fi
  if kubectl version --client; then
    locatiobino=$(which kubectl)
    cecho "[+] Install Validated in ${locatiobino}!"
    kubectl version --client
  else
    cecho "[-] Validation Failed, if you see a version output below, something strange is happening"
    kubectl version --client
  fi

  setupforkubernetes

  configure_c_groups_kubernetes

  build_install_cri_docker_d

}

installkind(){
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
  chmod +x ./kind
  mkdir ~/.kind/
  mv ./kind ~/.kind
}

installhelm(){
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3'

  chmod 700 get_helm.sh'

  ./get_helm.sh'

}
installansiblek8s(){
  ansible-galaxy collection install community.kubernetes'

}
#______________________________________________________________________________
# BEGIN DATA STORAGE SECTION
#______________________________________________________________________________