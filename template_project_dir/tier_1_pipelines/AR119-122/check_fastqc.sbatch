#!/bin/bash
#SBATCH --nodes=1
#SBATCH --output=fastqc-post.out
FASTQC_JOB_ID=$1
sacct -b -j $FASTQC_JOB_ID -P
ls -ltrh fastqc
tar -zcvf fastqc.tgz fastqc
