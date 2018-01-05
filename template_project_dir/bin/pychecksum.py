#!/usr/bin/env python
import sys,hashlib,os.path

progname = os.path.basename( sys.argv[0] )

def main(): 

    if len(sys.argv) < 2:
        print "usage: %s" % progname, "file_to_check", "algorithm", "\n\t-compute digest of file_to_check"
        print "usage: %s" % progname, "file_to_check", "algorithm", "digest", "\n\t-check 'digest' against computed from file_to_check, return 0 if match, 1 otherwise"
        print "usage: %s" % progname, "checksum.algorithm", "\n\t-Each line in checksum file contains the expected digest produced by algorithm in the file extension, and the filename to check, separated by two spaces (old md5sum format)"
        print "usage: %s" % progname, "algorithm=checksumfile.txt", "\n\t-Each line in checksum file contains the expected digest produced by algorithm in the file extension, and the filename to check, separated by two spaces (old md5sum format)"
        print "\nSupported algorithms: ", hashlib.algorithms_guaranteed
        sys.exit(0)

    # check entries in a checksum.algorithm file, or algorithm=checksumfile.txt
    elif len(sys.argv) == 2:
        checksum_file = sys.argv[1]
        if checksum_file.find('=') > 0:
            algorithm,filename = checksum_file.split('=')
            checksum_file = filename
        else:
            base,algorithm = os.path.splitext(checksum_file)

        algorithm = algorithm.lstrip('.')

        for line in file(checksum_file):
            digester = get_func(algorithm)
            expected, file_to_check = line.split()
            if os.path.exists( file_to_check ):
                print file_to_check, expected, checkfile(file_to_check, digester, expected)

    # digest of single file, optionally check against arg
    elif len(sys.argv) >= 3:
        file_to_check = sys.argv[1]
        algorithm = sys.argv[2]
        if algorithm not in hashlib.algorithms_guaranteed:
            print >>sys.stderr, "supplied", algorithm, "not in", hashlib.algorithms_guaranteed
            sys.exit(1)

        digester = get_func(algorithm)
        expected = None if len(sys.argv) < 4 else sys.argv[3]

        actual_digest, match = checkfile(file_to_check, digester, expected)

        print actual_digest,

        if match is not None:
            print "=?=", expected, match
            sys.exit( 0 if match else 1)
        else:
            print file_to_check, algorithm
            sys.exit(0)


def checkfile(file_to_check, digester, expected = None):
    print >>sys.stderr, "checking", file_to_check, "using", digester,
    if expected is not None: 
        print >>sys.stderr, "against", expected 
    else:
        print >>sys.stderr
        
    if not os.path.exists(file_to_check):
        print >>sys.stderr, "Error, expected file %s does not exist" % file_to_check
        return None,None

    digester.update( file( file_to_check ).read() )
    actual = digester.hexdigest()

    if expected is not None:
        return actual, actual == expected

    return actual, None



def get_func(algo):

    if algo not in  hashlib.algorithms_guaranteed:
        raise ValueError("supplied algorithm `%s' not supported in hashlib" % algo) 

    if algo == "md5":
        return hashlib.md5()

    if algo == "sha2":
        return hashlib.sha2()

    if algo == "sha224":
        return hashlib.sha224()

    if algo == "sha256":
        return hashlib.sha256()

    if algo == "sha384":
        return hashlib.sha384()

    if algo == "sha512":
        return hashlib.sha512()

    raise ValueError("supplied algorithm `%s' not supported in hashlib" % algo) 

main()
