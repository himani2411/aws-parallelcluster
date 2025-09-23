#!/bin/bash
set -e

BENCHMARK_NAME={{ benchmark_name }}
OSU_BENCHMARK_VERSION={{ osu_benchmark_version }}

# Adding a check to verify IMEX status is UP
if [ -f "/opt/parallelcluster/shared/check_imex_status.sh" ]; then
  srun bash -c "source /opt/parallelcluster/shared/check_imex_status.sh; verify_imex_is_up"
fi

module load openmpi

env

mpirun -np 2 --map-by ppr:1:node /shared/openmpi/osu-micro-benchmarks-${OSU_BENCHMARK_VERSION}/mpi/pt2pt/${BENCHMARK_NAME} > /shared/${BENCHMARK_NAME}.out
