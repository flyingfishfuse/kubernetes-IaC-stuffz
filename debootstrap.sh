#!/bin/bash

home_dir="/home/$USER"
SELF="$home_dir/test.sh" #$(realpath "$0")
echo "$SELF"
pxe_boot_folder=/var/lib/tftpboot

###############################################################################
# username for new VM/container/host creations
chroot_new_username="test"
# password for new VM/container/host creations
chroot_new_user_password="password"
###############################################################################

iso_build_folder="$home_dir/iso_build_folder"
image_location="$iso_build_folder/new_debian.iso"
pxe_config_location="$pxe_boot_folder/pxelinux.cfg"

# this is what defines ALL other network addressing
# in the script
pxe_dhcp_range="192.168.0.1,192.168.0.24"
EXTRA_PACKAGES="fluxbox openssh-server openssh-client"

ARCH='amd64'
COMPONENTS='main,contrib'
REPOSITORY="https://deb.debian.org/debian/"
# debian version
release="stable"
sudo debootstrap --arch "$ARCH" "$release" "$iso_build_folder" "$REPOSITORY"

build_new_os()
{
# create the build folder
mkdir "$iso_build_folder"

# begin pulling all necessary data for debian install
sudo debootstrap --arch "$ARCH" "$release" "$iso_build_folder" "$REPOSITORY"
sudo cp /etc/resolv.conf "$iso_build_folder/etc/resolv.conf"
sudo cp /etc/apt/sources.list "$iso_build_folder/etc/apt/"
sudo cp /etc/hosts "$iso_build_folder/etc/hosts"
}

prepare_chroot()
{
# mount in preparation for chroot
sudo mount -o bind /dev "$iso_build_folder/dev"
mount none -t devpts "$iso_build_folder/dev/pts"
sudo mount -o bind -t proc /proc "$iso_build_folder/proc"
sudo mount -o bind -t sys /sys "$iso_build_folder/sys"
mount --bind /run  "$iso_build_folder/run"
}

chroot_adduser_install_packages(){
cat << EOF | sudo chroot "$iso_build_folder"
useradd $chroot_new_username
passwd  "$chroot_new_user_password"
login "$chroot_new_username"
sudo -S apt-get update
sudo -S apt-get --no-install-recommends install wget debconf nano curl ${EXTRA_PACKAGES} #For package-building
sudo -S apt-get update  #clean the gpg error message
sudo -S apt-get install locales dialog  #If you don't talk en_US
sudo -S locale-gen en_US.UTF-8  # or your preferred locale
EOF
}

teardown_chroot()
{
umount -lf /proc
umount -lf /sys
umount -lf /dev/pts
}

create_OS_image()
{
# begin creation of the iso image to be used for PXE boot
mkdir -p image/{casper,isolinux,install}
}

init_pxe_configuration()
{
#Copy the ISO file to the directory that dnsmasq will serve as the TFTP root 
# directory, which is typically /var/lib/tftpboot
echo "[+] Moving new Debian ISO to PXE directory"
sudo cp "$image_location" "$pxe_boot_folder"
sudo touch $pxe_config_location

# apply pxe configuration
echo "[+] Applying PXE boot config"
cat << EOF | sudo tee -a $pxe_config_location
default install
label install
kernel debian-installer/i386/linux
append vga=normal initrd=debian-installer/i386/initrd.gz iso-scan/filename=/output.iso  ---
EOF
# apply dnsmasq configuration
cat << EOF | sudo tee -a /etc/dnsmasq.conf 
tftp-root=/var/lib/tftpboot
dhcp-boot=pxelinux.0,pxeserver,pxeserver
dhcp-range=$pxe_dhcp_range
EOF

# restart daemon to apply changes
sudo systemctl restart dnsmasq
}
