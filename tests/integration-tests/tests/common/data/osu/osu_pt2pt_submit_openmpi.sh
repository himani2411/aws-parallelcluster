#!/bin/bash
set -e

BENCHMARK_NAME={{ benchmark_name }}
OSU_BENCHMARK_VERSION={{ osu_benchmark_version }}

module load openmpi

env

mpirun -np 2 -N 2 --mca btl ^sm,vader --mca mtl ofi --mca mtl_ofi_provider_include efa  /shared/openmpi/osu-micro-benchmarks-${OSU_BENCHMARK_VERSION}/mpi/pt2pt/${BENCHMARK_NAME} > /shared/${BENCHMARK_NAME}_${SLURM_JOB_ID}_${SLURMD_NODENAME}.out
