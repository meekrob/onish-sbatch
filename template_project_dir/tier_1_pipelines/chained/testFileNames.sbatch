#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:01:00
#SBATCH --qos=debug
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root="${infile%%.fastq}" # delete the file extension
echo "infile is $infile"
echo "root is $root"

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension" 
    exit 1;
fi

outfile=${root}.dusted.fastq
echo "outfile is $outfile"

