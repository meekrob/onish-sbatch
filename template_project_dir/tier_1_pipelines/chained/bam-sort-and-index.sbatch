#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:07:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bam-sort.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.bam} # delete the file extension

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${root}.sorted.bam

# will samtools make use of this setting?
export TMPDIR=$SLURM_SCRATCH
export TEMPDIR=$SLURM_SCRATCH
cmd="samtools sort -o $outfile $infile"
time eval $cmd

# also create the index, will append a .bai
cmd="samtools index -b $outfile"
echo $cmd

time eval $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools command failed."
    exit $?
fi

#launch next job
next_outfile=${infile/.bam/.bed}
log=${next_outfile}.log-%j
sbatch -o $log pipeline/bam-to-bed.sbatch $outfile
pychecksum.py $outfile md5
