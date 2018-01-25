# Author: David C. King
#
# This file substitutes for a "module load" command on summit, for the bx environment.
# This file must be sourced rather than executed directly.
#
# Invoke this config file with "source /projects/dcking@colostate.edu/paths.bashrc"
# Or make an alias in your .bash_profile:
#   alias loadbx="source /projects/dcking@colostate.edu/paths.bashrc"
#
# This file is inspired by methods in the "activate" source file created by python virtualenv.
unloadbx() {

    #reset old environment variables, if they exist
    #  ! [ -z ${VAR+_} ] returns true if VAR is declared at all
    if ! [ -z "${_OLD_PATH+_}" ]; then
        PATH="$_OLD_PATH"
        export PATH
        unset _OLD_PATH
    fi
    if ! [ -z "${_OLD_PYTHONPATH+_}" ]; then
        PYTHONPATH="$_OLD_PYTHONPATH"
        export PYTHONPATH
        unset _OLD_PYTHONPATH
    fi
    if ! [ -z "${_OLD_LD_LIBRARY_PATH+_}" ]; then
        LD_LIBRARY_PATH="$_OLD_LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH
        unset _OLD_LD_LIBRARY_PATH
    fi
    if ! [ -z "${_OLD_MANPATH+_}" ]; then
        MANPATH="$_OLD_MANPATH"
        export MANPATH
        unset _OLD_MANPATH
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH-}" ] || [ -n "${ZSH_VERSION-}" ] ; then
         hash -r 2>/dev/null
    fi

    unset BX_ENV
    if [ ! "${1-}" = "nondestructive" ] ; then
    # Self destruct!
        unset -f unloadbx
    fi
}

unloadbx nondestructive

# directory for bioinformatics-related bin, lib, include, etc and other directories
BX=/projects/dcking@colostate.edu
BX_ENV="/projects/dcking@colostate.edu"


# store previous variables
_OLD_PATH="$PATH"

if ! [ -z "${PYTHONPATH+_}" ]
then
    _OLD_PYTHONPATH="$PYTHONPATH"
fi
if ! [ -z "${LD_LIBRARY_PATH+_}" ]
then
    _OLD_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
fi
if ! [ -z "${MANPATH+_}" ]
then
    _OLD_MANPATH="$MANPATH"
fi
echo -ne "Loading BX Environment... "

# R
export R_PROFILE_USER=$BX_ENV/RProfile

# binaries
BX_PATH=$BX_ENV/bin # macs2, others
BX_PATH=$BX_PATH:$BX_ENV/bin/bedtools2 # bedtools
BX_PATH=$BX_PATH:$BX_ENV/bin/bowtie1 # bowtie1
BX_PATH=$BX_PATH:$BX_ENV/bin/bowtie2 # bowtie2
BX_PATH=$BX_PATH:$BX_ENV/bin/sratoolkit # sratoolkit
BX_PATH=$BX_PATH:$BX_ENV/bin/UCSC-UserApps/ # UCSC
BX_PATH=$BX_PATH:$BX_ENV/bin/FastQC # FastQC/fastqc wrapper script is here, along with the endless java nonsense
BX_PATH=$BX_PATH:$BX_ENV/bin/cufflinks # cufflinks, linked to pre-compiled binaries in src
BX_PATH=$BX_PATH:$BX_ENV/bin/tophat # tophat, linked to pre-compiled binaries in src

# bowtie index dir needed for alignments
BOWTIE_INDEXES=$BX_ENV/support_data/bowtie-index
# runtime libraries
BX_LD=$BX_ENV/lib:$BX_ENV/lib/tbb # needed by UCSC-UserApps, bowtie1,2

export PYTHONPATH=$BX_ENV/lib/python2.7/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BX_LD
export PATH=$PATH:$BX_PATH
export MANPATH=$MANPATH:$BX_ENV/share/man
export PERL5LIB=$BX_ENV/lib/perl

# on the compile node, python for MACS, java for fastqc and javaGenomicsToolkit
if ! module load intel python jdk
then
    echo "Error with module command."
fi

echo -e "Environment loaded."
if [ -z "$ENVIRONMENT" ];
then
     echo -e "Type \e[90m'man paths.bashrc'\e[30m for more information."
fi;
