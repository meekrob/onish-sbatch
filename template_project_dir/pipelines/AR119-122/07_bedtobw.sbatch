#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-bedtobw.out
PROJ_DIR=/projects/dcking@colostate.edu
cl=$PROJ_DIR/support_data/ce11/ce11.chrom.sizes
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.bed"

cmd="bedToBw.sh $infile 150 $cl -n -bw"
echo $cmd
time $cmd
