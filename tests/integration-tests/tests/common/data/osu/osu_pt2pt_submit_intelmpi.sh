#!/bin/bash
set -e

BENCHMARK_NAME={{ benchmark_name }}
OSU_BENCHMARK_VERSION={{ osu_benchmark_version }}

module load intelmpi
export I_MPI_DEBUG=10

env

mpirun -bootstrap=slurm -np 2 -ppn 2 -genv I_MPI_SHM=0 -genv I_MPI_FABRICS=ofi -genv I_MPI_OFI_PROVIDER=efa /shared/intelmpi/osu-micro-benchmarks-${OSU_BENCHMARK_VERSION}/mpi/pt2pt/${BENCHMARK_NAME} > /shared/${BENCHMARK_NAME}_${SLURM_JOB_ID}_${SLURMD_NODENAME}.out
