#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --array=119-121
#SBATCH --output=outfiles/%a-%A-macs2-keep-dup-1.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
treatment="bam/AR${SLURM_ARRAY_TASK_ID}.sorted.bam"
echo $treatment
input=bam/AR122.sorted.bam
threshold=0.05
outroot=AR${SLURM_ARRAY_TASK_ID}_keepdup_1_$threshold
cmd="macs2 callpeak -t $treatment -c $input -f BAM -n $outroot -g ce --nomodel -m 10 30 --extsize=150 --q $threshold  --keep-dup 1"
echo $cmd
time $cmd
