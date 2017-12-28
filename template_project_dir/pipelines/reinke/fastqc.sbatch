#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:03:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-fastqc
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc

infile=$1
root=${infile%%.seq.dusted} # delete the file extension
echo "infile is $infile"
echo "root is $root"

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

cmd="fastqc --extract --threads=24 --outdir=$outdir $infile"
echo $cmd
time $cmd
