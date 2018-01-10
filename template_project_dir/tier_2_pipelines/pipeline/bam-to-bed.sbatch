#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:07:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bam-to-bed.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc

infile=$1
outfile=${infile/bam/bed}

cmd="bedtools bamtobed -i $infile > $outfile"
time eval $cmd
sbatch pipeline/bed-to-bw.sbatch $outfile
pychecksum.py $outfile sha512
