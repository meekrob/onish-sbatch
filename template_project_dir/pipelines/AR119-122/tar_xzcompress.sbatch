#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=0:30:00
#SBATCH --qos=normal
#SBATCH --output=tar_xz_%j.out
cmd="tar -cvf everythingAR119-22.tar `cat tar.list`"
echo $cmd
eval time $cmd
cmd="xz -9 -T 24 everythingAR119-22.tar"
echo $cmd
eval time $cmd
