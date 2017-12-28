#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:03:00
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-fastqc
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.trimmed.dusted.fastq"
outdir="fastqc"

if [ ! -d $outdir ] 
then 
    echo "creating outdir for fastqc";
    mkdir $outdir;
fi

cmd="fastqc --extract --threads=24 --outdir=$outdir $infile"
echo $cmd
time $cmd
sacct -b  -j $SLURM_ARRAY_JOB_ID -P
