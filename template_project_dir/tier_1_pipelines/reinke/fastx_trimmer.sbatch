#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:06:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-fastx_trimmer.out
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

outfile=${root}.trimmed.fastq


cmd="fastx_trimmer -i $infile -f 9 -o $outfile"
echo $cmd
eval time $cmd

if [ ! $? -eq 0  ]
then
    >&2 echo "tagdust failed on $infile"
    exit 1
fi

sbatch pipeline/tagdust.sbatch $outfile
