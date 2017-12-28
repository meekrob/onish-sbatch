#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-macs_cmb_reps.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line
PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc

# treatment list - $1 - a file with experiment short names that can be passed to compile_replicates.sh
treatment=$(pipeline/compile_replicates.sh $1)
# control list - $2 - same as $1/treatment list, but with the corresponding input file experiments
input=$(pipeline/compile_replicates.sh $2)
# outroot - $3 - what to name ${outroot}_peaks.xls and other files
outroot=$3
# Parameters for MACS2, see https://github.com/taoliu/MACS for more information
EXTSIZE=150    # fragment size according to sonication during sample preparation
KEEPDUP=auto   # What to do with duplicates: 1 - only keep 1; auto - discard those which exceed a binomial estimate; auto - don't discard.
DOBDG="-B"     # -B to create bedgraphs, leave blank otherwise
THRESHOLD=0.05 # q-value cut-off
MFOLD="10 30"  # is this ignored during --nomodel?
cmd="macs2 callpeak -t $treatment -c $input -f BAM -n $outroot -g ce --nomodel -m $MFOLD --extsize=$EXTSIZE --q $THRESHOLD  --keep-dup $KEEPDUP $DOBDG"
echo $cmd
time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "macs2 command failed."
    exit $?
fi

#launch next job
sbatch pipeline/MACS2xlsToBB.sbatch ${outroot}_peaks.xls
