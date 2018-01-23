#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-sam-to-bam.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.sam} # delete the file extension

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${root}.bam

cmd="samtools view -b -S ${infile} -o ${outfile}"
echo $cmd
time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools command failed."
    exit $?
fi

#launch next job
next_log=${root}.sorted.bam.log-%j # the next job's outfile plus .log-%j
sbatch -o $next_log pipeline/bam-sort.sbatch $outfile


