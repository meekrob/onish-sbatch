#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-bowtie.out
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile="AR$SLURM_ARRAY_TASK_ID.trimmed.dusted.fastq"
outfile="AR$SLURM_ARRAY_TASK_ID.sam"

cmd="bowtie -a -q -S --nomaqround -m 1 -p 12 --best --chunkmbs 200 --seed 123 $BOWTIE_INDEXES/ce11 $infile $outfile"
echo $cmd
time $cmd
