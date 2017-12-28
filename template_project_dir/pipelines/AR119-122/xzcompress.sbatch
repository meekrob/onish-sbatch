#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=8:00:00
#SBATCH --qos=normal
#SBATCH --output=xz_%j.out
cmd="xz -9 -T 20 $1"
echo $cmd
time $cmd
