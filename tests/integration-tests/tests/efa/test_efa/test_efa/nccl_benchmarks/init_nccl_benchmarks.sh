#!/usr/bin/env bash
set -e

rm -rf /shared/${1}

module load ${1}
NCCL_BENCHMARKS_VERSION='2.13.6'
NCCL_VERSION='2.18.3-1'
OFI_NCCL_VERSION='1.7.2-aws'
MPI_HOME=$(which mpirun | awk -F '/bin' '{print $1}')
NVCC_GENCODE="-gencode=arch=compute_90,code=sm_90" # Arch for NVIDIA H100

mkdir -p /shared/${1}

# Install and build nccl from sources
cd /shared/${1}
wget https://github.com/NVIDIA/nccl/archive/v${NCCL_VERSION}.tar.gz
tar zxvf "v${NCCL_VERSION}.tar.gz"
cd nccl-${NCCL_VERSION}
make -j src.build NVCC_GENCODE="${NVCC_GENCODE}"

# Build nccl-tests
cd /shared/${1}
wget https://github.com/NVIDIA/nccl-tests/archive/v${NCCL_BENCHMARKS_VERSION}.tar.gz
tar zxvf "v${NCCL_BENCHMARKS_VERSION}.tar.gz"
cd "nccl-tests-${NCCL_BENCHMARKS_VERSION}/"
NVCC_GENCODE="${NVCC_GENCODE}" make MPI=1 MPI_HOME=${MPI_HOME} NCCL_HOME=/shared/${1}/nccl-${NCCL_VERSION}/build/ CUDA_HOME=/usr/local/cuda

wget https://github.com/aws/aws-ofi-nccl/archive/v${OFI_NCCL_VERSION}.tar.gz
tar xvfz v${OFI_NCCL_VERSION}.tar.gz
cd aws-ofi-nccl-${OFI_NCCL_VERSION}
./autogen.sh
./configure --with-libfabric=/opt/amazon/efa --with-cuda=/usr/local/cuda/targets/x86_64-linux/ --with-nccl=/shared/openmpi/nccl-${NCCL_VERSION}/build/ --with-mpi=${MPI_HOME} --prefix /shared/openmpi/ofi-plugin
make
make install
