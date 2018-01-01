#!/usr/bin/env python
import sys,os,subprocess

arg = sys.argv[1]
jids = []
dirs = []
for d in os.listdir(arg):
    try:
        jids.append( d.split('-')[0] )
        dirs.append(d)
    except:
        print >>sys.stderr, "could not process %s" % d

dirs.sort(lambda a,b: cmp(int(a.split('-')[0]), int(b.split('-')[0])))

sacct_args = [ "sacct", 
                 "-PXn", # parseable (no ending '|'), job summary: no intermediate steps, no header
                 "--format",
                 "JobID,ExitCode",
                 "-j",
                 ",".join(jids)
             ]


if 1:
    try:
        whatis = subprocess.check_output( sacct_args )

        lines = whatis.split("\n")
        for d,line in zip(dirs, lines):
            code = line.split("|")[1]
            status = "failed" if code.startswith("1") else "OK"
            #print d,line,status
            if status == "failed":
                print os.path.join(arg, d)

    except subprocess.CalledProcessError as e:
        print >>sys.stderr, "There was an error in sacct", e
        raise e
