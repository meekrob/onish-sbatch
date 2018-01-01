#!/usr/bin/env python
import sys,os,subprocess

arg = sys.argv[1]
jids = []
for d in os.listdir(arg):
    if d.find('-') > 0:
        jids.append( d.split('-')[0] )
    
    
sacct_args = [ "sacct", 
                 "-X",
                 "--format",
                 "JobID,JobName,AllocCPUS,State,ExitCode,Elapsed,TimeLimit,Submit,Start,End",
                 "-j", 
                 ",".join(jids)
             ]
try:
    print subprocess.check_output( sacct_args )
except subprocess.CalledProcessError as e:
    print >>sys.stderr, "There was an error in sacct", e
    raise e
