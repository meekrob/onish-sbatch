#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --partition=smem
#SBATCH --output=outfiles/%j-smem--bed-to-bw.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
cl=$PROJ_DIR/support_data/ce11/ce11.chrom.sizes
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.bed} # delete the file extension

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi
# the outfile name is not specified in the command but will take the following form:
outfile=${root}x150n.bw
cmd="bedToBw.sh $infile 150 $cl -n -bw"
echo $cmd
eval time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "bedToBw.sh command failed."
    exit $?
fi

