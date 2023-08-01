#!/bin/bash
set -e

rm -f /shared/mpi.out
module load openmpi
mpirun --map-by ppr:1:node --timeout 80 "ring" >> /shared/mpi.out
