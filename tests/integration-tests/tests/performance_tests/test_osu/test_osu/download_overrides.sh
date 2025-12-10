#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <s3-bucket-name>"
    exit 1
fi

BUCKET_NAME="$1"
FILE_NAME="run_instance_overrides.json"
INSTALL_PATH="/opt/slurm/etc/pcluster/run_instances_overrides.json"

if aws s3 cp "s3://$BUCKET_NAME/$FILE_NAME" "$INSTALL_PATH"; then
    echo "Successfully downloaded $FILE_NAME to $INSTALL_PATH"
else
    echo "Failed to download $FILE_NAME from s3://$BUCKET_NAME/"
    exit 1
fi