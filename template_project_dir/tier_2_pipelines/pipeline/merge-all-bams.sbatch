#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-mergebams.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc

outfile=$1
shift
infiles=$@

cmd="samtools merge -@ 23 $outfile $infiles"
echo $cmd
time eval $cmd

pychecksum.py $outfile sha512
