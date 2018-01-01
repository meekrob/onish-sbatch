##BXDIR= # needs to be set during configuration/install
alias loadbx='source $BXDIR/paths.bashrc'
alias sa='sacct -X --format JobID,JobName,AllocCPUS,State,ExitCode,Elapsed,TimeLimit,Submit,Start,End'
alias sq='squeue -u $USER'
echo_notfound()
{
    notfound=$@
    if [ ! -z "$notfound" ];
    then
        echo -e "\e[47m'outfiles' does not contain \e[1m$notfound\e[0m";
    fi
}
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
    notfound=""
    for j in `echo $jid | sed 's/,/ /g'`; 
    do 
        if [ -e outfiles/$j* ]
        then
            cmd="ls $@ outfiles/$j*"
            echo -e "\033[1m$cmd\033[0m" 
            eval $cmd
        else
            notfound="$j $notfound"
        fi
    done
    echo_notfound $notfound
}

catj ()
{
    notfound=""
    for j in `echo $jid | sed 's/,/ /g'`; 
    do 
        if [ -e outfiles/$j* ]
        then
            cmd="cat $@ outfiles/$j*"
            echo -e "\033[1m$cmd\033[0m" 
            eval $cmd
        else
            notfound="$j $notfound"
        fi
    done
    echo_notfound $notfound
}
headj ()
{
    notfound=""
    for j in `echo $jid | sed 's/,/ /g'`; 
    do 
        if [ -e outfiles/$j* ]
        then
            cmd="head $@ outfiles/$j*"
            echo -e "\033[1m$cmd\033[0m" 
            eval $cmd
        else
            notfound="$j $notfound"
        fi
    done
    echo_notfound $notfound
}
tailj ()
{
    notfound=""
    for j in `echo $jid | sed 's/,/ /g'`; 
    do 
        if [ -e outfiles/$j* ]
        then
            cmd="tail $@ outfiles/$j*"
            echo -e "\033[1m$cmd\033[0m" 
            eval $cmd
        else
            notfound="$j $notfound"
        fi
    done
    echo_notfound $notfound
}
