#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-macs.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc

### Input files ###
treatment=$1
input=$2

### Parameters for MACS2, see https://github.com/taoliu/MACS for more information ###
EXTSIZE=150    # fragment size according to sonication during sample preparation
KEEPDUP=auto   # What to do with duplicates: 1 - only keep 1; auto - discard those which exceed a binomial estimate; auto - don't discard.
DOBDG="-B"     # -B to create bedgraphs, leave blank otherwise
THRESHOLD=0.05 # q-value cut-off
MFOLD="10 30"  # is this ignored during --nomodel?

# LOG PARAMETERS
echo "EXTSIZE=$EXTSIZE"
echo "KEEPDUP=$KEEPDUP"
echo "DOBDG=$DOBDG"
echo "THRESHOLD=$THRESHOLD"
echo "MFOLD=$MFOLD"

# Include KD in outname
outroot="${3}_kd_${KEEPDUP}"
outfile=${outroot}_peaks.xls # anticipated outfile name

# LOG FILENAMES
echo treatment="$treatment"
echo input="$input"
echo outroot="$outroot"
echo outfile="$outfile"

### run command
cmd="macs2 callpeak -t $treatment -c $input -f BAM -n $outroot -g ce --nomodel -m $MFOLD --extsize=$EXTSIZE --q $THRESHOLD  --keep-dup $KEEPDUP $DOBDG"
echo $cmd
time $cmd

pychecksum.py $outfile sha512

if [ $? -ne 0 ]
then
    >&2 echo "macs2 command failed."
    exit $?
fi

###launch next job
sbatch pipeline/MACS2xlsToBB.sbatch $outfile
