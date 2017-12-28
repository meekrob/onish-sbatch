#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:05:45
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-sam-to-bam.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.sam"
outfile="AR$SLURM_ARRAY_TASK_ID.bam"

cmd="samtools view -b -S ${infile} -o ${outfile}"
echo $cmd
time $cmd
