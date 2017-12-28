alias sa='sacct -X --format JobID,JobName,AllocCPUS,State,ExitCode,Elapsed,TimeLimit,Submit,Start,End'
alias sq='squeue -u $USER'
sb ()
{
    j=$(sbatch --parsable $@)
    if [ -z $jid ];
    then
        jid=$j;
    else
        jid=$jid,$j
    fi
    echo "Submitted batch job $j. \$jid set to $jid"
}
alias saj='sa -j $jid'
lsj ()
{
    for j in `echo $jid | sed 's/,/ /g'`; 
    do 
        ls $@ outfiles/$j*; 
    done
}

