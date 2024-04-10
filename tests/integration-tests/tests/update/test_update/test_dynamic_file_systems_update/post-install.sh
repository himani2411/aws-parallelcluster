#!/bin/bash

set -xe

# Check the pcluster version
PCLUSTER_VERSION_OUTPUT=$(cat /opt/parallelcluster/.bootstrapped)
echo "'pcluster version' output: $PCLUSTER_VERSION_OUTPUT"

if [[ $PCLUSTER_VERSION_OUTPUT =~ .*([0-9]+\.[0-9]+\.[0-9]+).* ]]; then
    PCLUSTER_VERSION="${BASH_REMATCH[1]}"
    echo "Found pcluster version $PCLUSTER_VERSION"
else
    echo "Error: cannot find the pcluster version"
    exit 1
fi
# download the patch
CWD=$(pwd)
PATCH_DIR="$CWD/recursive-delete"
mkdir -p $PATCH_DIR

PATCH="$PATCH_DIR/$PCLUSTER_VERSION.patch"
S3_BUCKET="s3://aws-parallelcluster-dev-commercial-dev/patches/recursive-delete"
aws s3 cp $S3_BUCKET/$PCLUSTER_VERSION.patch $PATCH_DIR/$PCLUSTER_VERSION.patch

# execute the update to the cookbook
COOKBOOK_DIR="/etc/chef"

cd $COOKBOOK_DIR
git apply $PATCH
cd $CWD
