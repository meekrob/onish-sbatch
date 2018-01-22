#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:00:30
#SBATCH --qos=debug
#SBATCH --output=%j-test_pipe.out

cmd='ls -al | wc -l'
echo $cmd
eval time $cmd
