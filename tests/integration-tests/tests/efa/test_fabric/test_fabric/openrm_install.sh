#!/bin/bash

set -x
#logfile=openrm_log.txt
#exec > $logfile 2>&1
# Installing NVIDIA 535.54.03 Runfile

sudo yum update -y

nvidia_version="535.54.03"

wget https://us.download.nvidia.com/tesla/${nvidia_version}/NVIDIA-Linux-x86_64-${nvidia_version}.run -O /tmp/nvidia.run
chmod +x /tmp/nvidia.run

cd /tmp
echo "Uninstalling NVIDIA Driver"
./nvidia.run --uninstall --silent

echo "Testing Nvidia driver version"
[[ $(nvidia-smi | grep -E -o "No such file or directory") != "No such file or directory" ]] && "ERROR Uninstalling NVIDIA driver was not successful" && exit 1


echo "Installing OpenRM Driver"
CC=/usr/bin/gcc10-gcc ./nvidia.run --silent --dkms --disable-nouveau --no-cc-version-check -m=kernel-open
actual_driver_version=$(nvidia-smi | grep -E -o "Driver Version: [0-9.]+")

[[ "${actual_driver_version}" != "Driver Version: ${nvidia_version}" ]] && "ERROR Installed version ${actual_driver_version} but expected ${nvidia_version}" && exit 1
echo "Correctly installed OpenRM ${actual_driver_version}"


## GDRCopy
old_gdrcopy_version=$(modinfo -F version gdrdrv)
new_gdrcopy_version="2.4"

echo "Uninstalling GDRCopy ${old_gdrcopy_version}"
rpm -e gdrcopy-kmod
rpm -e gdrcopy-devel
rpm -e gdrcopy

echo "Downloading GDRCopy ${new_gdrcopy_version}"

wget https://github.com/NVIDIA/gdrcopy/archive/refs/tags/v${new_gdrcopy_version}.tar.gz -O /opt/parallelcluster/sources/gdrcopy-${new_gdrcopy_version}.tar.gz
yum -y install dkms rpm-build make check check-devel subunit subunit-devel


cd /opt/parallelcluster/sources
tar -xf gdrcopy-${new_gdrcopy_version}.tar.gz

cd gdrcopy-${new_gdrcopy_version}/packages/

echo "Installing GDRCopy ${new_gdrcopy_version}"

CUDA=/usr/local/cuda ./build-rpm-packages.sh
rpm -q gdrcopy-kmod-${new_gdrcopy_version}-1dkms || rpm -Uvh gdrcopy-kmod-${new_gdrcopy_version}-1dkms.amzn-2.noarch.rpm
rpm -q gdrcopy-${new_gdrcopy_version}-1.x86_64 || rpm -Uvh gdrcopy-${new_gdrcopy_version}-1.amzn-2.x86_64.rpm
rpm -q gdrcopy-devel-${new_gdrcopy_version}-1.noarch || rpm -Uvh gdrcopy-devel-${new_gdrcopy_version}-1.amzn-2.noarch.rpm

actual_gdrcopy_version=$(modinfo -F version gdrdrv)
[[ "${actual_gdrcopy_version}" != "${new_gdrcopy_version}" ]] && "ERROR Installed version ${actual_gdrcopy_version} but expected ${new_gdrcopy_version}" && exit 1
echo "Correctly installed GDRCopy ${new_gdrcopy_version}"


## Installing EFA 1.29.0
old_efa_version=$(cat /opt/amazon/efa_installed_packages | grep -E -o "EFA installer version: [0-9.]+")
new_efa_version="1.29.0"

echo "Downloading EFA ${new_efa_version}"
wget https://efa-installer.amazonaws.com/aws-efa-installer-${new_efa_version}.tar.gz -P /opt/parallelcluster/sources/

cd /opt/parallelcluster/sources/

tar -xzf aws-efa-installer-${new_efa_version}.tar.gz

cd aws-efa-installer
echo "Uninstalling ${old_efa_version}"
./efa_installer.sh -u -y

echo "Installed EFA installer version: ${new_efa_version}"
./efa_installer.sh -y

actual_efa_version=$(cat /opt/amazon/efa_installed_packages | grep -E -o "EFA installer version: [0-9.]+")

[[ "${actual_efa_version}" != "EFA installer version: ${new_efa_version}" ]] && "ERROR Installed version ${actual_efa_version} but expected ${new_efa_version}" && exit 1
echo "Correctly installed EFA ${new_efa_version}"

## Clean Up
echo "Cleaning Up"
rm -rf /tmp/nvidia.run
rm -rf /opt/parallelcluster/sources/aws-efa-installer
./usr/local/sbin/ami_cleanup.sh
echo "Completed!"
