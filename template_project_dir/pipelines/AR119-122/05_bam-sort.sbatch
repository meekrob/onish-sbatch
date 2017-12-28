#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:07:00
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-bam-sort.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.bam"
outfile="AR$SLURM_ARRAY_TASK_ID.mt.sorted.bam"

cmd="samtools sort -@ 23 -o $outfile $infile"
echo $cmd
time $cmd
