#!/bin/bash

me=$(basename "$0")
doit=
kvm_root=/var/lib/kvm
debian_image_url="https://cloud.debian.org/images/cloud"
ubuntu_image_url="https://cloud-images.ubuntu.com"
seed=seed.iso

ncpu=1
mem=2
disk=10
name=
image=
release=trixie
distro=debian

function die() {
	echo "$@"
	exit 1
}

function map_debian_release() {
	local rel=$1
	case "$rel" in
		"forky") echo "14" ;;
		"trixie") echo "13" ;;
		"bookworm") echo "12" ;;
		"bullseye") echo "11" ;;
		"buster") echo "10" ;;
		*) die "Unknown release: ${rel}" ;;
	esac
}

function get_arch() {
	proc=$(uname -m)
	if [ "$proc" == "x86_64" ]; then
		arch="amd64"
	else
		die "Unknown procesor"
	fi
}
get_arch

function usage_header() {
cat <<EOH
Create a virtual machine, using Debian or Ubuntu as the base.

Usage:
  ${me} command [options]

Options:

EOH
}

function usage_download() {
cat <<EOH
  download            download a cloud image from ${debian_image_url}
    -a,--arch         CPU arch, default: ${arch}
    -r,--release      Debian release, default: ${release}
    -D,--debian       Use Debian, default
    -U,--ubuntu       Use Ubuntu
EOH
}

function usage_vm() {
cat <<EOH
  vm                  create a virtual machine
    -h,--help         this help text
    -n,--name         name of the vm
    -c,--cpus         number of CPUs to add, default: ${ncpu}
    -m,--memory       RAM in GB, default: ${mem}
    -d,--disk-size    disk size in GB, default: ${disk}
    -r,--release      Debian release to use
    -D,--debian       Use Debian, default
    -U,--ubuntu       Use Ubuntu
    -N,--dry-run      don't do it
EOH
}

function usage() {
	cat <<EOH
$(usage_header)

$(usage_download)

$(usage_vm)

EOH
}

handle_opts_download() {
	if [ $# -eq 0 ]; then
		usage_download && exit 1
	else
		while [[ $# -gt 0 ]]; do
			case "$1" in
				-h|--help) usage_download && exit 0 ;;
				-r|--release) release=$2 && shift 2 ;;
				-a|--arch) arch=$2 && shift 2 ;;
				-D|--debian) distro=debian && shift ;;
				-U|--ubuntu) distro=ubuntu && shift ;;
				--) shift && break ;;
				*) die "Unknown option: $1" ;;
			esac
		done
	fi
}

handle_opts_vm() {
	if [ $# -eq 0 ]; then
		usage_vm && exit 1
	else
		while [[ $# -gt 0 ]]; do
			case "$1" in
				-h|--help) usage_vm && exit 0 ;;
				-c|--cpus) ncpu=$2 && shift 2 ;;
				-m|--memory) mem=$2 && shift 2 ;;
				-d|--disk-size) disk=$2 && shift 2 ;;
				-n|--name) name=$2 && shift 2 ;;
				-r|--release) release=$2 && shift 2 ;;
				-D|--debian) distro=debian && shift ;;
				-U|--ubuntu) distro=ubuntu && shift ;;
				-N|--dry-run) doit=echo && shift ;;
				--) shift && break ;;
				*) die "Unknown option: $1" ;;
			esac
		done
	fi

	if [[ -z "$name" ]]; then die "A name is required for the vm"; fi
}

function download_image() {
	local url=$1
	test -f ${kvm_root}/images/${release}.qcow2 || sudo wget \
	  -O ${kvm_root}/images/${release}.qcow2 \
	"${url}"
}

function prep_kvm() {
	# Make the vm folder
	$doit sudo mkdir -vp ${kvm_root}/vms/${name}
}

function make_disk() {
	sudo cp ${kvm_root}/images/${release}.qcow2 ${kvm_root}/vms/${name}/${name}.qcow2
	sudo qemu-img resize -q ${kvm_root}/vms/${name}/${name}.qcow2 ${disk}
}

function make_seed() {
	sudo tee ${kvm_root}/vms/${name}/user-data <<EOM
#cloud-config
users:
- name: $(whoami)
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh_authorized_keys:
    - $(cat /home/$(whoami)/.ssh/id*.pub)

# 2. Update the package lists and install the OpenSSH server
package_update: true
packages:
  - openssh-server

# 3. Ensure the service is enabled and actively running
runcmd:
  - systemctl enable ssh
  - systemctl start ssh
EOM

	sudo tee ${kvm_root}/vms/${name}/meta-data <<EOM
local-hostname: ${name}
EOM
	$doit sudo cloud-localds ${kvm_root}/vms/${name}/seed.iso \
	${kvm_root}/vms/${name}/user-data \
	${kvm_root}/vms/${name}/meta-data
}

function make_vm() {
	local variant=""
	if [ "$distro" == "debian" ]; then
		variant="debian${release}"
	else
		variant="ubuntu-lts-latest"
	fi

	$doit sudo virt-install \
	  --name ${name} \
	  --memory $((${mem} * 1024)) \
	  --vcpus ${ncpu} \
	  --disk ${kvm_root}/vms/${name}/${name}.qcow2,device=disk,bus=virtio,format=qcow2 \
	  --disk ${kvm_root}/vms/${name}/${seed},device=cdrom \
	  --os-variant ${variant} \
	  --network network=default,model=virtio \
	  --noautoconsole \
	  --import
}

function start_vm() {
	virsh start ${name}
}

# prep
test -d ${kvm_root}/vms || $doit sudo mkdir -p ${kvm_root}/vms
test -d ${kvm_root}/images || $doit sudo mkdir -p ${kvm_root}/images

command="$1"
shift

if [ "$command" == "download" ]; then
	handle_opts_download "$@"
	version=
	if [ "$distro" == "debian" ]; then
		version=$(map_debian_release ${release})
		download_image ${debian_image_url}/${release}/latest/debian-${version}-genericcloud-${arch}.qcow2
	else
		download_image ${ubuntu_image_url}/${release}/current/${release}-server-cloudimg-${arch}.img
	fi
elif [ "$command" == "vm" ]; then
	handle_opts_vm "$@"
	prep_kvm
	make_disk
	make_seed
	make_vm
	sudo virsh dominfo ${name}
	sudo virsh domifaddr ${name}
else
	usage
	exit 0
fi

