#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:5:00
#SBATCH --qos=normal
#SBATCH --array=0-8
#SBATCH --output=outfiles/%a-%A-gunzip.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

infile="$(ls ${SLURM_ARRAY_TASK_ID}_*.seq.gz)"
cmd="gunzip -v $infile"
echo $cmd
time eval $cmd
sbatch pipeline/tagdust.sbatch ${infile%%.gz}
