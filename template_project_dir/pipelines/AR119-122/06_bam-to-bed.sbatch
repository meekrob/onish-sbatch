#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:07:00
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-sorted.bam-to-bed.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.sorted.bam"
outfile="AR$SLURM_ARRAY_TASK_ID.bed"
cmd="bedtools bamtobed -i $infile > $outfile"
echo $cmd
eval time $cmd
