import argparse

def generateMaskVerifS5(l, s, IOrefresh='inputs', MatRefresh='low', dummyRand='none'):
    #IOrefresh='none', 'output', 'inputs', 'both'
    #MatRefresh= 'none', 'low', 'right', 'both'
    #dummyRand= 'none', 'output', 'inputs', 'both'

    output = ""
    output += "(* tSNI verification of S5_%d_%d using MaskVerif tool *)\n\n" %(l,s)

    if (dummyRand == 'inputs') or (dummyRand == 'both'):
        output += "proc S5_%d_%d_AND:\n" % (l,s)
        output += "  inputs: x[0:%d], y[0:%d]\n" % (l-1, l-1)
    else:
        output += "proc S5_%d_%d_AND:\n" % (l,s)
        output += "  inputs: x[0:%d], y[0:%d]\n" % (l+s-2, l+s-2)

    if (dummyRand == 'output') or (dummyRand == 'both'):
        output += "  outputs: z[0:%d]\n" % (l-1)
    else:
        output += "  outputs: z[0:%d]\n" % (l+s-2)

    output += "  randoms: "
    #Handling Dummy as random instead of inputs
    if (dummyRand == 'inputs') or (dummyRand == 'both'):
        for line in range(l,l+s-1):
            output += "dumX%d, " % line

        for line in range(l,l+s-1):
            output += "dumY%d, " % line

    # Handling Matrix refresh
    if (MatRefresh == 'right') or (MatRefresh == 'both'):
        for line in range(l):
            output += "refR%d_%d, " % (line,l-1)
        for column in range(l+1,l+s-1):
            for line in range(l-1):
                output += "refR%d_%d, " % (line, column)
    if (MatRefresh == 'low') or (MatRefresh == 'both'):
        for line in range(l,l-1+s):
            for column in range(l-1):
                output += "refL%d_%d, " % (line,column)
    if (MatRefresh == 'low') or (MatRefresh == 'none'):
        for line in range(l):
            output += "v%d, " % (line)

    # Handling randoms of input / output refresh
    if (IOrefresh == 'inputs') or (IOrefresh == 'both'):
        for i in range(1,s):
            output += "refX_%d, " % (i+l-1)
        for i in range(1,s):
            output += "refY_%d, " % (i+l-1)
    if (IOrefresh == 'output') or (IOrefresh == 'both'):
        for i in range(1,s):
            output += "refZ_%d, " % (i+l-1)

    for line in range(l-3):
        for column in range(line+1,l-1):
            output += "r%d_%d, " % (line,column)
    output += "r%d_%d;\n" % (l-3,l-2)

    if (IOrefresh == 'inputs') or (IOrefresh == 'both'):
        output += "\n  (* ----------Refreshing Inputs---------- *)\n\n" #######################################

        for line in range(l):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  x%d := dumX%d;\n" % (line, line)
            else:
                output += "  x%d := x[%d];\n" % (line, line)
        for line in range(l,s+l-1):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  x%d := dumX%d + refX_%d;\n" % (line, line, line)
            else:
                output += "  x%d := x[%d] + refX_%d;\n" % (line, line, line)

        output += "\n"

        for line in range(l):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  y%d := dumY%d;\n" % (line, line)
            else:
                output += "  y%d := y[%d];\n" % (line, line)
        for line in range(l,s+l-1):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  y%d := dumY%d + refY_%d;\n" % (line, line, line)
            else:
                output += "  y%d := y[%d] + refY_%d;\n" % (line, line, line)
    else:
        output += "\n"
        for line in range(l-1+s):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  x%d := dumX%d;\n" % (line, line)
            else:
                output += "  x%d := x[%d];\n" % (line, line)

        output += "\n"

        for line in range(l-1+s):
            if (line >= l) and (dummyRand == 'inputs' or dummyRand == 'both'):
                output += "  y%d := dumY%d;\n" % (line, line)
            else:
                output += "  y%d := y[%d];\n" % (line, line)

    if (MatRefresh == 'right') or (MatRefresh == 'both'):
        assert s >= 3, "Number of slots s should be greater or equal than three. Currently, s=%d\n\n" % s

        output += "\n  (* ----------Computing random vector such that their sum is equal to zero---------- *)\n\n" #######################################

        for line in range(l-1):
            output += "  v%d_%d := refR%d_%d;\n" % (0,line, line,l+1)
        output += "\n"
        for line in range(l-1):
            ctr=1
            for column in range(l+2, l+s-1):
                output += "  v%d_%d := v%d_%d + refR%d_%d;\n"% (ctr,line, ctr-1,line, line,column)
                ctr+=1
            output += "\n"
        for line in range(l-1):
            output += "  refR%d_%d := v%d_%d;\n" % (line,l, s-3,line)

        #TODO: the sum of the OTHER vect should be equal to zero !

    output += "\n  (* ----------Phase 1---------- *)\n" #######################################

    for line in range(1,l-1):
        output += "\n  (* line %d *)\n" % line
        for column in range(line):
            output += "  t1_%d_%d := x%d * y%d;\n" % (line,column, line, column)
            output += "  t2_%d_%d := t1_%d_%d + r%d_%d;\n" % (line,column, line,column, column,line)
            output += "  t3_%d_%d := x%d * y%d;\n" % (line,column, column, line)
            output += "  t4_%d_%d := t3_%d_%d + t2_%d_%d;\n\n" % (line,column, line,column, line,column)

    for i in range(l-1):
        output += "  u%d := x%d * y%d;\n" % (i, i, i)

    output += "\n  (* ----------Phase 2---------- *)\n\n" #######################################

    if (MatRefresh == 'right') or (MatRefresh == 'both'):
        for line in range(l-1,l-1+s):
            output += "  (* line %d *)\n" % line
            for column in range(l-1):
                output += "  w%d_%d_%d := x%d * y%d;\n" % (1,line,column, column, line)
                output += "  w%d_%d_%d := w%d_%d_%d + refR%d_%d;\n" % (2,line,column, 1,line,column, column,line)
                output += "  w%d_%d_%d := x%d * y%d;\n" % (3,line,column, line, column)
                if ((MatRefresh == 'low') or (MatRefresh == 'both')) and (line != l-1):
                    output += "  w%dt_%d_%d := w%d_%d_%d + refL%d_%d;\n" % (4,line,column, 3,line,column, line,column)
                    output += "  w%d_%d_%d := w%dt_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 4,line,column, 2,line,column)
                else:
                    output += "  w%d_%d_%d := w%d_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 3,line,column, 2,line,column)
            output += "\n"
    else:
        for line in range(l-1,l-1+s):
            output += "  (* line %d *)\n" % line
            for column in range(l-1):
                output += "  w%d_%d_%d := x%d * y%d;\n" % (1,line,column, column, line)
                output += "  w%d_%d_%d := w%d_%d_%d + v%d;\n" % (2,line,column, 1,line,column, column)
                output += "  w%d_%d_%d := x%d * y%d;\n" % (3,line,column, line, column)
                if MatRefresh == 'low' and (line != l-1):
                    output += "  w%dt_%d_%d := w%d_%d_%d + refL%d_%d;\n" % (4,line,column, 3,line,column, line,column)
                    output += "  w%d_%d_%d := w%dt_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 4,line,column, 2,line,column)
                else:
                    output += "  w%d_%d_%d := w%d_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 3,line,column, 2,line,column)
            output += "\n"

    for line in range(s):
        output += "  u%d := x%d * y%d;\n" % (line+l-1, line+l-1, line+l-1)

    output += "\n  (* ----------Phase 3---------- *)\n\n" #######################################

    if (MatRefresh == 'right') or (MatRefresh == 'both'):
        for line in range(l):
            output += "  z0_%d := refR%d_%d + u%d;\n" % (line, line,l-1, line)
        output += "\n"
    else:
        for line in range(l):
            output += "  z0_%d := v%d + u%d;\n" % (line, line, line)
        output += "\n"

    for line in range(l-1):
        output += "\n  (* line %d *)\n" % line
        for column in range(line):
            output += "  z%d_%d := z%d_%d + t%d_%d_%d;\n" % (column+1,line,  column,line, 4,line,column)
        for column in range(line+1, l-1):
            output += "  z%d_%d := z%d_%d + r%d_%d;\n" % (column,line,  column-1,line, line,column)
        output += "\n"

    for i in range(l-1):
        if (line >= l) and (dummyRand == 'output' or dummyRand == 'both'):
            output += "  Zdum%d := z%d_%d;\n" % (i, l-2,i)
        else:
            output += "  z[%d] := z%d_%d;\n" % (i, l-2,i)

    output += "\n  (* ----------Phase 4---------- *)\n\n" #######################################

    for line in range(l-1,l-1+s):
        output += "  z%d_%d := w%d_%d_%d + u%d;\n" % (0,line, 4,line,0, line)

    output += "\n"

    for line in range(s):
        output += "\n  (* line %d *)\n" % (line+l-1)
        for column in range(1,l-1):
            output += "  z%d_%d := z%d_%d + w%d_%d_%d;\n" % (column,line+l-1, column-1,line+l-1, 4,line+l-1,column)
        output += "\n"

    if (IOrefresh == 'output') or (IOrefresh == 'both'):
        output += "\n  (* ----------Refreshing Outputs---------- *)\n\n" #######################################

        output += "  z[%d] := z%d_%d;\n" % (l-1, l-2,l-1)
        for line in range(l,l-1+s):
            if (line >= l) and (dummyRand == 'output' or dummyRand == 'both'):
                output += "  Zdum%d := z%d_%d + refZ_%d;\n" % (line, l-2,line, line)
            else:
                output += "  z[%d] := z%d_%d + refZ_%d;\n" % (line, l-2,line, line)

    else:
        for line in range(l-1,l-1+s):
            if (line >= l) and (dummyRand == 'output' or dummyRand == 'both'):
                output += "  Zdum%d := z%d_%d;\n" % (line, l-2, line)
            else:
                output += "  z[%d] := z%d_%d;\n" % (line, l-2, line)

    output += "\nend\n\n"

    for i in range(1, l):
        output += "order %d noglitch SNI S5_%d_%d_AND\n" % (i,l,s)

    return(output)


if __name__ == '__main__' and '__file__' in globals():
    parser = argparse.ArgumentParser(
        description='description to do later',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        '-l', '--linear-shares', type=int, default=5,
        help="Number of linear shares"
    )

    parser.add_argument(
        '-s', '--slots', type=int, default=5,
        help="Number of slots"
    )

    parser.add_argument(
        '-IO', '--IOrefresh', type=str, default="inputs",
        help="Where to apply input/output refresh ? IOrefresh='none', 'output', 'inputs', 'both'"
    )

    parser.add_argument(
        '-Mat', '--MatRefresh', type=str, default='low',
        help="Refreshing slots inside the matrix ? MatRefresh='none', 'right', 'low', 'both'"
    )

    parser.add_argument(
        '-dum', '--dummyRand', type=str, default='none',
        help="Do we consider the dummy slots as not inputs but random values ? 'none', 'output', 'inputs', 'both'"
    )

    args = parser.parse_args()

    print(generateMaskVerifS5(args.linear_shares, args.slots, IOrefresh=args.IOrefresh, MatRefresh=args.MatRefresh, dummyRand=args.dummyRand))
