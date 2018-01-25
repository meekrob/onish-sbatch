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

if  echo $infile | grep -o "sorted.bam$" > /dev/null
then
    root=${infile%%.sorted.bam} # delete the file extension
elif echo $infile | grep -o "merged.bam$" > /dev/null
then
    root=${infile%%.merged.bam} # delete the file extension
else
    root=${infile%%.bam}
fi

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${root}.bed

cmd="bedtools bamtobed -i $infile > $outfile"
eval time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "bedtools command failed."
    exit $?
fi

#launch next job
next_outfile=${outfile%%.bed}.x150n.bw 
log=${next_outfile}.log-%j # literal '%j'
sbatch -o $log pipeline/bed-to-bw.sbatch $outfile
pychecksum.py $outfile md5
