#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:30:00
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-bedgraph2bw.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
chromlen=$PROJ_DIR/support_data/ce11/ce11.chrom.sizes
##############################
fileroot=$1 #prefix such as ELT2.0
treat=${fileroot}_treat_pileup.bdg
input=${fileroot}_control_lambda.bdg

for filearg in $treat $input;
do
    # assure sorted input
    sorted=${filearg/.bdg/.sorted.bdg}
    if [ ! -e $sorted ];
    then
        echo "Sorting $filearg to $sorted"
        cmd="sort -k1,1 -k2,2n $filearg > $sorted"
        echo -e "\t$cmd"
        time eval $cmd
    fi
    # convert to big wig
    bw=${sorted/.sorted.bdg/.bw}
    echo "Converting sorted bdg $sorted to bigwig $bw"
    cmd="bedGraphToBigWig $sorted $chromlen $bw"
    echo -e "\t$cmd"
    time eval $cmd
    pychecksum.py $bw sha512
done

