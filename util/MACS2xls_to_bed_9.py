#!/usr/bin/python
import sys, math, os, subprocess

ce11_chrom_sizes = "/projects/dcking@colostate.edu/support_data/ce11/ce11.chrom.sizes"

autosql_template = """
table %s
"MACS2 output adapted to bed9+ format"
(
string  chrom;      "Reference sequence chromosome or scaffold"
uint    chromStart; "Start position of feature on chromosome"
uint    chromEnd;   "End position of feature on chromosome"
string  name;       "Name of gene"
uint    score;      "Fold Enrichment scaled from [%.1f,%.1f] to [0,1000]. %.1f = %d."
char[1] strand;     "Always ."
uint    thickStart; "Will use the single position abs_summit"
uint    thickEnd;   "thickStart +1"
uint    reserved;   "Color strength according to score"
uint    fold;       "Fold enrichment (rounded to nearest int)"
uint    qvalue;     "-log 10 qvalue (rounded to nearest int)"
uint    pvalue;     "-log 10 pvalue (rounded to nearest int)"
string  mouseOver;  "Fold enrichment| -log10(q-value)| -log10(-pvalue)"
)
"""  # needs tablename, fold_min, fold_max, fold_threshold, f(fold_threshold)


# Documentation says XLS is 1-based, so subtract 1 to get bed position
#  0     1      2     3          4       5         6                7               8         9
# chr  start   end  length  abs_summit pileup -log10(pvalue) fold_enrichment -log10(qvalue)  name
#

def toward_white(r, g, b, t):
    R = int(r + (255 - r)*t)
    G = int(g + (255 - g)*t)
    B = int(b + (255 - b)*t)
    return (R,G,B)

printed_mode_yet = False

def parse_line_to_dict(line):
    global printed_mode_yet
    fields = line.split()
    nfields = len(fields)
    if nfields < 10:
        raise ValueError("line does not have the expected number of fields:`%s'" % line)

    r = {}
    # the three that are the same
    r['chrom'] = fields[0]
    r['start'] = int(fields[1]) - 1
    r['end'] = int(fields[2]) 
    r['strand'] = '.'

    r['abs_summit'] = int(fields[4]) - 1
    r['-log10_pvalue']   = float( fields[6] )
    r['fold_enrichment'] = float( fields[7] )
    r['-log10_qvalue']   = float( fields[8] )
    r['name'] = fields[9] # name supplied by MACS2

    # use the MACS called "summit" as the thick point
    if r['abs_summit'] == r['end']:
        # sometimes the summit is called exactly on the end coordinate
        r['thickStart'] = r['abs_summit'] -1
        r['thickEnd'] = r['abs_summit'] 
    else:        
        r['thickStart'] = r['abs_summit'] 
        r['thickEnd'] = r['abs_summit'] + 1

    # give a mouseOver column
    r['mouseOver'] = "%.2f|%.2fq|%.2fp" % (r['fold_enrichment'], r['-log10_qvalue'], r['-log10_pvalue'])

    return r

def validate_exe(program):

    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return True
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return True

    return False

def main():

    if validate_exe('bedToBigBed'):
        # do nothing
        pass
    else:
        print >>sys.stderr, "bedToBigBed is not in your $PATH, you must install this program to proceed."
        sys.exit(1)


    try:
        datafile = sys.argv[1]
        outputdir,nodir = os.path.split(datafile)
        dataname = os.path.splitext(nodir)[0]
        maxcolor = sys.argv[2]
        colors = map(float, maxcolor.split(','))
    except:
        print >>sys.stderr, "Error:\nUsage:%s infile.xls r,g,b" % sys.argv[0]
        sys.exit(1)

    # write to user's current directory
    outputdir = '.'
    
    starting_range = (0.0,15.0)
    target_range = (0.0,1000.0)

    # build conversion function
    starting_min = min(starting_range)
    starting_max = max(starting_range)
    starting_span = starting_range[1] - starting_range[0]
    target_min = min(target_range)
    target_span = target_range[1] - target_range[0]

    projection = lambda x: target_min + (target_span * ((x - starting_min) / starting_span)) 
    threshold = 10.0

    # fill out autosql_template
    # dataname must be truncated
    dataname_trunc = dataname[:17].rstrip('_').rstrip('.')
    dataname_trunc = dataname_trunc.replace('.','_')
    autosql = autosql_template % (dataname_trunc, starting_min, starting_max, threshold, projection(threshold))
    asfile = file(os.path.join(outputdir, dataname + '.as'), "w")
    asfile.write(autosql)
    asfile.close()
    print >>sys.stderr, "wrote %s" % asfile.name

    # output file
    outfile = file(os.path.join(outputdir,dataname + '.bed9_3'),"w")
    output_lines = 0
    for line in open(sys.argv[1]):
        line = line.strip()

        # some comments, blanks in header
        if len(line) == 0:
            continue
        if line.startswith('#'):
            continue
        if line.startswith('chr\t'):
            continue

        row = parse_line_to_dict( line ) 

        # convert fold enrichment range to [0,1000]
        bed_score = min(1000, projection( row['fold_enrichment'] ) )
        row['bed_score'] = int(round( bed_score ))

        # reduce brightness of user-supplied color by above score / 1000
        factor = 1 - float(bed_score) / 1000
        r,g,b = toward_white(colors[0], colors[1], colors[2], factor)
        adj_color = ",".join( map(str, (r,g,b)))
        row['reserved'] = adj_color

        
        try:
            print >>outfile, "\t".join( map(str, [
                    row['chrom'],  # 0
                    row['start'],  # 1
                      row['end'],  # 2
                     row['name'],  # 3
                row['bed_score'],  # 4
                   row['strand'],  # 5
               row['thickStart'],  # 6
                 row['thickEnd'],  # 7
                 row['reserved'],  # 8
                int( round (row['fold_enrichment'] ) ), # 9
                int( round (row['-log10_qvalue'] ) ),   # 10
                int( round (row['-log10_pvalue'] ) ),   # 11
                row['mouseOver']  # 12
            ]))
            output_lines += 1
        except:
            print >>sys.stderr, "here's adj_color", adj_color
            print >>sys.stderr, sys.exc_info()[0]
            raise

    outfile.close()
    print >>sys.stderr, "wrote %d lines to %s" % (output_lines, outfile.name)

    # run the bedToBigBed command
    fileroot, ext = os.path.splitext(outfile.name)
    bbfilename = fileroot + '.bb'
    bb_args = ["bedToBigBed", "-as=" + asfile.name, "-type=bed9+3", outfile.name, ce11_chrom_sizes, bbfilename]
    print >>sys.stderr, "preparing to run `%s`" % " ".join(bb_args)

    try:
        subprocess.check_output( bb_args )
    except subprocess.CalledProcessError as e:
        print >>sys.stderr, "There was an error in bedToBigBed", e
        raise e
        
main()
