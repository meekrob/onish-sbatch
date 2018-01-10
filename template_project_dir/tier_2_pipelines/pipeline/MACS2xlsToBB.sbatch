#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:00:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-macs2xls2bigbed.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
xls=$1
color="0,0,0"
cmd="MACS2xls_to_bed_9.py $xls $color"
echo $cmd
time $cmd
pychecksum.py ${xls/.xls/.bb} sha512
