#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=0:02:30
#SBATCH --qos=normal
#SBATCH --array=119-120
#SBATCH --output=outfiles/%a-%A-subtractbw.out
root="AR$SLURM_ARRAY_TASK_ID"
suffix="x150n"
filearg=$root${suffix}.bw
source $PRJ/paths.bashrc
cmd1="javaGenomicsToolkit wigmath.Subtract -f -p 12 -m $filearg -s AR121x150n.bw -o ${root}overAR121.wig"
echo $cmd1
time $cmd1
celengthfile="$BX_ENV/support_data/ce11/ce11.chrom.sizes"
cmd2="wigToBigWig ${root}overAR121.wig ${celengthfile} ${root}overAR121.bw"
echo $cmd2
time $cmd2
