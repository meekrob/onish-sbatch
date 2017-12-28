#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-macs.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
treatment=$1
input=$2
threshold=0.05
#outroot=${treatment%%.sorted.bam}
outroot=${treatment%%.merged.bam}
cmd="macs2 callpeak -t $treatment -c $input -f BAM -n $outroot -g ce --nomodel -m 10 30 --extsize=150 --q $threshold  --keep-dup 1"
echo $cmd
time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "macs2 command failed."
    exit $?
fi

#launch next job
sbatch pipeline/MACS2xlsToBB.sbatch ${outroot}_peaks.xls
