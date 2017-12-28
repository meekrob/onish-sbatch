#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bowtie.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
echo "infile is $infile"

root=${infile%%.seq.dusted} # delete the file extension

echo "root is $root"

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${root}.sam
echo "outfile is $outfile"

# run bowtie
cmd="bowtie -a -q -S --nomaqround -m 1 -p 12 --best --chunkmbs 200 --seed 123 $BOWTIE_INDEXES/ce11 $infile $outfile"
echo $cmd
time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "bowtie command failed."
    exit 1
fi

# check for output file integrity
cmd="samtools quickcheck $outfile"
echo $cmd
eval $cmd
if [ $? -ne 0 ]
then
    >&2 echo "bowtie command passed, but the output file \'$outfile\' failed integrity check."
    exit 1
fi

# launch next job
sbatch pipeline/sam-to-bam.sbatch $outfile
