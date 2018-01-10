#!/bin/bash
# read in a file with the short name of an experiment listed, such are AR120 or EO30,
# find the corresponding BAM file in "datadir", and concatenate the results onto
# a single line
resolve_paths() {
    list=$(grep -v '#' $1)
    list_ext=$?;
    if [ $list_ext != 0 ];
    then 
        echo "previous line exitted with $list_ext"; 
        exit $list_ext;
    fi
    paths=""
    while read -r line;
    do
        filepath=$(ls $datadir/${line}*.bam)
        paths="$filepath $paths"
        
    done <<< "$list"
    echo $paths
}
datadir="../all"

paths=$(resolve_paths $1)
#echo "resolved to \`$paths'"
echo $paths

