def generateMaskVerifS5(l, s, refresh=False):
    output = ""
    output += "(* tSNI verification of S5_%d_%d using MaskVerif tool *)\n\n" %(l,s)
    output += "proc S5_%d_%d_AND:\n" % (l,s)
    output += "  inputs: x[0:%d], y[0:%d]\n" % (l+s-2, l+s-2)
    output += "  outputs: z[0:%d]\n\n" % (l+s-2)
    output += "  randoms: "
    if refresh:
        for i in range(1,s):
            output += "refX_%d, " % (i+l-1)
        for i in range(1,s):
            output += "refY_%d, " % (i+l-1)
    for line in range(l-1):
        for column in range(line+1,l):
            output += "r%d_%d, " % (line,column)
    for column in range(l-1):
        output += "v%d, " % column
    output += "v%d;\n" % (l-1)

    if refresh:
        output += "\n  (* ----------Refreshing Inputs---------- *)\n\n" #######################################
        for i in range(l):
            output += "  x%d := x[%d];\n" % (i, i)
        for i in range(l,s+l-1):
            output += "  x%d := x[%d] + refX_%d;\n" % (i, i, i)
        output += "\n"

        for i in range(l):
            output += "  y%d := y[%d];\n" % (i, i)
        for i in range(l,s+l-1):
            output += "  y%d := y[%d] + refY_%d;\n" % (i, i, i)
        output += "\n  (* ----------Phase 1---------- *)\n\n" #######################################

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

        for line in range(l-1,l-1+s):
            output += "  (* line %d *)\n" % line
            for column in range(l-1):
                output += "  w%d_%d_%d := x%d * y%d;\n" % (1,line,column, column, line)
                output += "  w%d_%d_%d := w%d_%d_%d + v%d;\n" % (2,line,column, 1,line,column, column)
                output += "  w%d_%d_%d := x%d * y%d;\n" % (3,line,column, line, column)
                output += "  w%d_%d_%d := w%d_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 3,line,column, 2,line,column)
            output += "\n"

        for line in range(s):
            output += "  u%d := x%d * y%d;\n" % (line+l-1, line+l-1, line+l-1)

        output += "\n  (* ----------Phase 3---------- *)\n\n" #######################################

        for i in range(l):
            output += "  z0_%d := v%d;\n" % (i, i)
        output += "\n"

        for line in range(l-1):
            output += "\n  (* line %d *)\n" % line
            for column in range(line):
                output += "  z%d_%d := z%d_%d + t%d_%d_%d;\n" % (column+1,line,  column,line, 4,line,column)
            for column in range(line+1, l-1):
                output += "  z%d_%d := z%d_%d + r%d_%d;\n" % (column,line,  column-1,line, line,column)
            output += "\n"

        for i in range(l-1):
            output += "  z[%d] := z%d_%d;\n" % (i, l-2,i)

        output += "\n  (* ----------Phase 4---------- *)\n\n" #######################################

        for line in range(l-1,l-1+s):
            output += "  z%d_%d := w%d_%d_%d;\n" % (0,line, 4,line,0)

        output += "\n"

        for line in range(s):
            output += "\n  (* line %d *)\n" % (line+l-1)
            for column in range(1,l-1):
                output += "  z%d_%d := z%d_%d + w%d_%d_%d;\n" % (column,line+l-1, column-1,line+l-1, 4,line+l-1,column)
            output += "\n"

        for line in range(s):
            output += "  z[%d] := z%d_%d;\n" % (line+l-1, l-2, line+l-1,)

    #---------------------------- END CASE REFRESH ----------------------------#

    else:
        output += "\n  (* ----------Phase 1---------- *)\n\n" #######################################

        for line in range(1,l-1):
            output += "\n  (* line %d *)\n" % line
            for column in range(line):
                output += "  t1_%d_%d := x[%d] * y[%d];\n" % (line,column, line, column)
                output += "  t2_%d_%d := t1_%d_%d + r%d_%d;\n" % (line,column, line,column, column,line)
                output += "  t3_%d_%d := x[%d] * y[%d];\n" % (line,column, column, line)
                output += "  t4_%d_%d := t3_%d_%d + t2_%d_%d;\n\n" % (line,column, line,column, line,column)

        for i in range(l-1):
            output += "  u%d := x[%d] * y[%d];\n" % (i, i, i)

        output += "\n  (* ----------Phase 2---------- *)\n\n" #######################################

        for line in range(l-1,l-1+s):
            output += "  (* line %d *)\n" % line
            for column in range(l-1):
                output += "  w%d_%d_%d := x[%d] * y[%d];\n" % (1,line,column, column, line)
                output += "  w%d_%d_%d := w%d_%d_%d + v%d;\n" % (2,line,column, 1,line,column, column)
                output += "  w%d_%d_%d := x[%d] * y[%d];\n" % (3,line,column, line, column)
                output += "  w%d_%d_%d := w%d_%d_%d + w%d_%d_%d;\n\n" % (4,line,column, 3,line,column, 2,line,column)
            output += "\n"

        for line in range(s):
            output += "  u%d := x[%d] * y[%d];\n" % (line+l-1, line+l-1, line+l-1)

        output += "\n  (* ----------Phase 3---------- *)\n\n" #######################################

        for i in range(l):
            output += "  z0_%d := v%d;\n" % (i, i)
        output += "\n"

        for line in range(l-1):
            output += "\n  (* line %d *)\n" % line
            for column in range(line):
                output += "  z%d_%d := z%d_%d + t%d_%d_%d;\n" % (column+1,line,  column,line, 4,line,column)
            for column in range(line+1, l-1):
                output += "  z%d_%d := z%d_%d + r%d_%d;\n" % (column,line,  column-1,line, line,column)
            output += "\n"

        for i in range(l-1):
            output += "  z[%d] := z%d_%d;\n" % (i, l-2,i)

        output += "\n  (* ----------Phase 4---------- *)\n\n" #######################################

        for line in range(l-1,l-1+s):
            output += "  z%d_%d := w%d_%d_%d;\n" % (0,line, 4,line,0)

        output += "\n"

        for line in range(s):
            output += "\n  (* line %d *)\n" % (line+l-1)
            for column in range(1,l-1):
                output += "  z%d_%d := z%d_%d + w%d_%d_%d;\n" % (column,line+l-1, column-1,line+l-1, 4,line+l-1,column)
            output += "\n"

        for line in range(s):
            output += "  z[%d] := z%d_%d;\n" % (line+l-1, l-2, line+l-1,)

    output += "\nend\n\n"

    for i in range(1, l):
        output += "order %d noglitch SNI S5_%d_%d_AND\n" % (i,l,s)

    return(output)

print(generateMaskVerifS5(4,2,refresh=True))
