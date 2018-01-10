#!/bin/bash
# This is NOT a slurm script, it is a wrapper to launch sbatch 

sbatch_cmd="sbatch pipeline/macs.sbatch"
term_to_green="\e[32m"
term_to_blue="\e[34m"
term_to_bold="\033[1m"
term_to_grey="\e[90m"
term_to_black="\033[0m"
term_invert="\e[7m"
term_uninvert="\e[27m"
term_reset="\e[0m"

# to make padding easier
i=$term_invert
u=$term_uninvert

if [ $# -eq 0 ];
then
    echo -e "Usage: $term_to_bold$term_to_blue$0 group.list$term_reset\n"
    echo -e "Runs '$term_to_grey${term_to_bold}$sbatch_cmd <exp> <control> <outname>${term_reset}' using arguments from a file like..."
    echo -e "\nExample $term_reset$term_to_bold${term_to_blue}group.list$term_to_black:"
    echo -ne "$term_to_bold"
    echo -e "#outname exp control       "
    echo -e "ELT2.0 AR112 AR114         "
    echo -e "IgG.0 AR113 AR114          "
    echo
    echo -e "${term_reset}Lines beginning with ${term_to_grey}${term_to_bold}'#'${term_reset} are ignored."
    exit 1
fi

datadir="../all"
list=$(grep -v '#' $1)

while read -r line;
do
    outname=$(echo $line | cut -f1 -d ' ')
    file1=$(echo $line | cut -f2 -d ' ')
    file2=$(echo $line | cut -f3 -d ' ')
    p1=$(ls $datadir/${file1}*.bam)
    p2=$(ls $datadir/${file2}*.bam)
    cmd="$sbatch_cmd $p1 $p2 $outname"
    echo $cmd
    eval $cmd
    
    
done <<< "$list"

