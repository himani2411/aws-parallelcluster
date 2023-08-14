#!/bin/bash
set -e

rm -f /shared/mpi.out
module load openmpi
mpirun -x LD_LIBRARY_PATH= /opt/amazon/libfabric/lib:$LD_LIBRARY_PATH --map-by ppr:1:node --timeout 20 "ring" >> /shared/mpi.out
