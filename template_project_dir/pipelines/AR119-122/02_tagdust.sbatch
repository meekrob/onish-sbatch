#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --array=119-122
#SBATCH --output=outfiles/%a-%A-tagdust.out

source /projects/dcking@colostate.edu/paths.bashrc
SPA=/projects/dcking@colostate.edu/support_data/solexa-library-seqs.fasta

infile="AR$SLURM_ARRAY_TASK_ID.trimmed.fastq"
outfile="AR$SLURM_ARRAY_TASK_ID.trimmed.dusted.fastq"
artifacts="AR$SLURM_ARRAY_TASK_ID.trimmed.dusted.artifacts"
cmd="tagdust -f .001 $SPA $infile -o $outfile -a $artifacts" 
echo $cmd
time eval $cmd
