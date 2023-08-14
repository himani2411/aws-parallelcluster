#!/bin/bash

#SBATCH --export=ALL
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=3
#SBATCH --job-name=imb2
#SBATCH --output=runscript.out

module load intelmpi
mpirun -x LD_LIBRARY_PATH= /opt/amazon/libfabric/lib:$LD_LIBRARY_PATH -n 6 IMB-MPI1 Alltoall -npmin 2
