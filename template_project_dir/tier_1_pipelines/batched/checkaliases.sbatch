#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:00:10
#SBATCH --qos=debug
#SBATCH --output=compute_node_env_dump.out
echo "aliases"
alias
echo "set"
set
