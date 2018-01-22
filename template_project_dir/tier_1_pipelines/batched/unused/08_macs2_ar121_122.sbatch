#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-macs2_ar121_122.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
igg=AR121.sorted.bam
input=AR122.sorted.bam
threshold=0.005
outroot=AR121_122_$threshold
cmd="macs2 callpeak -t $igg -c $input -f BAM -n $outroot -g ce --nomodel --extsize=75 --q $threshold"
echo $cmd
time $cmd
