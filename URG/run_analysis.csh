#!/bin/csh
#
## LSF batch script to run the test MPI code
#
#BSUB -P P48500028                     # Project 99999999
#BSUB -x                               # exclusive use of node (not_shared)
#BSUB -n 1                             # number of total (MPI) tasks
#BSUB -R "span[ptile=1]"               # run a max of 8 tasks per node
#BSUB -q geyser
#BSUB -J scatter_snotel                # job name
#BSUB -o scatter_snotel.out            # output filename
#BSUB -e scatter_snotel.err            # error filename
#BSUB -W 6:00                         # wallclock time
#BSUB -q premium                       # queue

cd /glade/p/ral/RHAP/karsten/conus_ioc/analysis/rscripts-modeleval/URG
mpirun.lsf ./Rcmd.sh
