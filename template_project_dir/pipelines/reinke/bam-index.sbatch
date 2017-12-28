#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:01:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bam-index.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.bam} # delete the file extension

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

cmd="samtools index -b $infile"
echo $cmd

time eval $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools index failed."
    exit $?
fi

