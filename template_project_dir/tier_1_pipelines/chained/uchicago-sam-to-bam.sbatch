#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:05:30
#SBATCH --qos=normal
#SBATCH --output=outfiles/%j-sam-to-bam.out
echo "[$0] $SLURM_JOB_NAME $@" # log the command line

PROJ_DIR=/projects/dcking@colostate.edu
source $PROJ_DIR/paths.bashrc
infile=$1
root=${infile%%.sam} # delete the file extension

if [ "$root" == "$infile" ]
then
    >&2 echo "$infile did not have the expected file extension"
    exit 1;
fi

outfile=${root}.bam

###
# The following parameters were given to me by Alec Victorsen at U Chicago.
# -F 1548 -q 30
# https://broadinstitute.github.io/picard/explain-flags.html
# The samtools flags are a bitwise OR of the following options :
#   read paired (0x1)
#   read mapped in proper pair (0x2)
#   read unmapped (0x4)
#   mate unmapped (0x8)
#   read reverse strand (0x10)
#   mate reverse strand (0x20)
#   first in pair (0x40)
#   second in pair (0x80)
#   not primary alignment (0x100)
#   read fails platform/vendor quality checks (0x200)
#   read is PCR or optical duplicate (0x400)
#   supplementary alignment (0x800)
#
# 0x4 | 0x8 | 0x200 | 0x400 = 4 + 8 + 512 + 1024 = 1548
# We do not have paired reads. So ignore 0x4 and 0x8: 1536
filter="-F 1536"
# -q INT    Skip alignments with MAPQ smaller than INT [0]. 
quality=30

cmd="samtools view -b $filter $quality -S ${infile} -o ${outfile}"
echo $cmd
time $cmd

if [ $? -ne 0 ]
then
    >&2 echo "samtools command failed."
    exit $?
fi

#launch next job
next_log=${root}.sorted.bam.log-%j # the next job's outfile plus .log-%j
sbatch -o $next_log pipeline/bam-sort.sbatch $outfile


