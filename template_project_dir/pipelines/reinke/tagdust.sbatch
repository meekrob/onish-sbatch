#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-tagdust.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.seq} # delete the file extension
echo "infile is $infile"
echo "root is $root"

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${infile}.seq.dusted
echo "outfile is $outfile"
artifacts=${infile}.seq.dusted.artifacts
SPA=/projects/dcking@colostate.edu/support_data/solexa-library-seqs.fasta
cmd="tagdust -f .001 $SPA $infile -o $outfile -a $artifacts"
echo $cmd
time eval $cmd

if [ $? -ne 0 ]
then
    >&2 echo "tagdust failed on $infile"
    exit 1
fi

# launch next job(s)
sbatch pipeline/bowtie.sbatch $outfile
sbatch pipeline/fastqc.sbatch $outfile
