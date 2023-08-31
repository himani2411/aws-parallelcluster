#!/bin/bash
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --ntasks-per-node=8


module load openmpi
NCCL_VERSION='2.18.3-1'
mpirun \
-x FI_PROVIDER="efa" \
-x FI_EFA_USE_DEVICE_RDMA=1 \
-x LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib:/usr/local/cuda-12.1/lib64:/shared/openmpi/nccl-${NCCL_VERSION}/build/lib/:/shared/openmpi/ofi-plugin/lib/:$LD_LIBRARY_PATH \
-x RDMAV_FORK_SAFE=1 \
-x NCCL_ALGO=ring \
-x NCCL_NVLS_ENABLE=1 \
-x NCCL_DEBUG=WARNING \
-x NCCL_PROTO=simple \
--mca pml ^cm --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
/shared/openmpi/nccl-tests-2.13.6/build/all_reduce_perf -b 8 -e 2G -f 2 -g 1 -c 1 -n 100 > /shared/nccl_tests.out
