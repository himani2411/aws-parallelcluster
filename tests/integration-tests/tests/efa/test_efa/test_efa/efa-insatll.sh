#!/bin/bash

set -ex

## Installing EFA 1.29.0
old_efa_version=$(cat /opt/amazon/efa_installed_packages | grep -E -o "EFA installer version: [0-9.]+")
new_efa_version="1.30.0"

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

rm -rf /opt/parallelcluster/sources/aws-efa-installer
