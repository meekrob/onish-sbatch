#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bam-subsample.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
float_arg=$1
infile=$2

root=${infile%%.bam}

outfile=${root}.subset.bam

cmd="samtools view -s $float_arg -b $infile -o $outfile"
echo $cmd

time eval $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools command failed."
    exit $?
fi

