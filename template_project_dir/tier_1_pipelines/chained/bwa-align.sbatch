#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bwa.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line
export TMPDIR=$SLURM_SCRATCH

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
input=$1 # will be called like ../03_DUSTED/file.fastq
echo "input: $input"
output=$(basename ${input%.*}).sam
echo "output: $output"
genome=ce11.unmasked.fa
cmd="bwa mem $genome $input > $output"
echo $cmd
time eval $cmd
# submit the next command in chain
sbatch -o ${output/.sam/.bam}.log-%j  pipeline/uchicago-sam-to-bam.sbatch $output
# filestamp
pychecksum.py $output md5
