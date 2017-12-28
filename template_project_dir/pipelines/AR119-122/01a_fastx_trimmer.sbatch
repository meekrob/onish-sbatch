#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:06:30
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-fastx_trimmer.out

source /projects/dcking@colostate.edu/paths.bashrc
infile="fastqxz/AR$SLURM_ARRAY_TASK_ID.fastq"
outfile="AR$SLURM_ARRAY_TASK_ID.trimmed.fastq"
cmd="fastx_trimmer -i $infile -f 9 -o $outfile"
echo $cmd
eval time $cmd
