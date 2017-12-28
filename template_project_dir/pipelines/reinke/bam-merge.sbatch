#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:30:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bam-merge.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile1=$1
infile2=$2
root1=${infile1%%.seq.sorted.bam} # delete the file extension
root2=${infile2%%.seq.sorted.bam} # delete the file extension


outfile=${root1}.${root2}.merged.bam

cmd="samtools merge -@ 23 $outfile $infile1 $infile2"
echo $cmd

time eval $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools command failed."
    exit $?
fi

#launch next job
#sbatch pipeline/bam-to-bed.sbatch $outfile
