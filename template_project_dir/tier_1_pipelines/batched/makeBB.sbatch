#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=0:12:30
#SBATCH --qos=normal
source $PRJ/paths.bashrc
cmd="bedToBigBed AR120.bed $BX_ENV/support_data/ce11/ce11.chrom.sizes -type=bed6 AR120.bb"
echo $cmd
time $cmd
