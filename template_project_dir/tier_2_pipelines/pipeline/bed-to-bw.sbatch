#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --partition=smem
#SBATCH --output=outfiles/%j-smem-bed-to-bw.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
cl=$PROJ_DIR/support_data/ce11/ce11.chrom.sizes
source $PROJ_DIR/paths.bashrc

# the output filename cannot be specified 
# on the command line, but can be derived this way:
infile=$1
flank=150
root=${infile%%.bed} # delete the file extension
outfile=${root}x${flank}n.bw
## script invocation
cmd="bedToBw.sh $infile $flank $cl -n -bw"
time eval $cmd
pychecksum.py $outfile sha512
