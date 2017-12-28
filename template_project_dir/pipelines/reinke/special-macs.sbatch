#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-special-macs-all.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
treatment=$1
input=$2
threshold=0.05
#outroot=${treatment%%.sorted.bam}
outroot=${treatment%%_merged.bam}
cmd="macs2 callpeak -t $treatment -c $input -f BAM -n ${outroot}_kd_all -g ce --nomodel -m 10 30 --extsize=150 --q $threshold  --keep-dup all -B"
echo $cmd
time $cmd

