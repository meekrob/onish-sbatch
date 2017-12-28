#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --array=119-121
#SBATCH --output=outfiles/%a-%A-macs2-posShift-weakerq.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
igg=AR$SLURM_ARRAY_TASK_ID.sorted.bam
input=AR122.sorted.bam
threshold=0.01
_122_posShift_=_122_posShift_
outroot=AR$SLURM_ARRAY_TASK_ID$_122_posShift_$threshold
cmd="macs2 callpeak -t $igg -c $input -f BAM -n $outroot -g ce --nomodel -m 10 30 --shift 75 --extsize=150 --q $threshold"
#try with modelling
#cmd="macs2 callpeak -t $igg -c $input -f BAM -n $outroot -g ce -m 10 30 --q $threshold"
echo $cmd
time $cmd
