import argparse
import pathlib
import os
import sys
import io
from tqdm import tqdm

# load("./attacks/SelectionAndNodeVectors.sage")
# load("./attacks/SlidingWindow.sage")
from transposeTraces import getNodeVectors

#The regular AES Sbox
sbox =  [0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67,
    0x2b, 0xfe, 0xd7, 0xab, 0x76, 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59,
    0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0, 0xb7,
    0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1,
    0x71, 0xd8, 0x31, 0x15, 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05,
    0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75, 0x09, 0x83,
    0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29,
    0xe3, 0x2f, 0x84, 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
    0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf, 0xd0, 0xef, 0xaa,
    0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c,
    0x9f, 0xa8, 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc,
    0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2, 0xcd, 0x0c, 0x13, 0xec,
    0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19,
    0x73, 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee,
    0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb, 0xe0, 0x32, 0x3a, 0x0a, 0x49,
    0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4,
    0xea, 0x65, 0x7a, 0xae, 0x08, 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6,
    0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a, 0x70,
    0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9,
    0x86, 0xc1, 0x1d, 0x9e, 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e,
    0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf, 0x8c, 0xa1,
    0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0,
    0x54, 0xbb, 0x16]

ToyAESkey = 97 #Must match ToyAESkey value used in the creation of the ToyAES

#Since there are only 256 possible input values and one key possibility, we
#predict the value of the selection function for each of them

SelFuncTable = []
for input in range(256):
    SelFuncTable.append(sbox[input^^ToyAESkey]&0b1)

def SelectionFunction(input):
    return(SelFuncTable[input])

def AbsCorr(v1,v2,T):
    matches = 0
    for i in range(T):
        matches += v1[i] ^^ v2[i] ^^ 1
    if matches > T/2 :
        return((matches - (T/2))/(T/2))
    else :
        return((T - matches - (T/2))/(T/2))

def sigma_test(vec1, vec2, T, k):
    """Test if bias is larger than k*stddev."""
    matches = 0
    for i in range(T):
        matches += int(vec1[i] == vec2[i])
    deviation = abs(matches - T/2)
    sigma = T**0.5 / 2.0
    return deviation > k*sigma

def maxCorIdx(L):
    maxCor = 0
    maxCorIndex = -1
    for i in range(256):
        if L[i] > maxCor:
            maxCor = L[i]
            maxCorIndex = i
    return(maxCorIndex)

def RequiredAmountOfTraces(W, Ord):
    neededTraces=30 #Supplementary traces to avoid false positives with probability 1/2^30
    for o in range(2,Ord+1):
        neededTraces+=binomial(W,Ord)
    return(W+neededTraces)

def XORlists(L1,L2):
    return([L1[i]^^L2[i] for i in range(len(L1))])

def ExtXORTheWindow(W, Ord):
    ExtW = W.copy()
    for combSize in range(2,Ord+1):
        for comb in Combinations(W, combSize):
            ExtW.append(XORlists(comb[0],comb[1]))
    return(ExtW)

def ParaHODCA(path, T, W, S, Ord=2, begining=0, ending=0, Record=0):
    assert Ord >= 2, "The order O should be greater than one. For order equal to one, run DCA instead"

    (NodeVectors, nodesToGoThrough, begining, ending) = getNodeVectors(path, T, begining=begining, ending=ending, NonRedundantNodes=None, silent=1)
    NodeVectors = list(NodeVectors)
    NodeVectors = [[int(x) for x in row] for row in NodeVectors]

    PLAINTEXTS=[]
    for traceNumber in range(T):
        fpt = path / ("%04d.pt" % traceNumber)
        with open(fpt, "rb") as f:
            PLAINTEXTS += [f.read(1)[0]]

    AllSelVectors = []
    for key in range(256):
        keySelVect = []
        for pt in PLAINTEXTS:
            keySelVect.append(sbox[pt^^key]&0b1)
        AllSelVectors.append(keySelVect)
    SelectionVector = [SelectionFunction(pt) for pt in PLAINTEXTS]

    BestAbsCorOfSv = [0 for _ in range(256)]

    nmax = (len(NodeVectors)-W)//S

    for n in tqdm(range(nmax)):
        #Win = SlidingWindow(NodeVectors, W, S, n, Type='List')
        Win = NodeVectors[n*S:n*S+W]
        for o in range(2,Ord+1):
            ExtWin = ExtXORTheWindow(Win,Ord)
            for Nv in ExtWin:
                for i in range(256):
                    Corr = AbsCorr(Nv, AllSelVectors[i], T)
                    if Corr > BestAbsCorOfSv[i]:
                        BestAbsCorOfSv[i] = Corr

    if Record:
        HODCAresult = open("resultParaHODCA.txt", "a")

    if AllSelVectors[maxCorIdx(BestAbsCorOfSv)] == SelectionVector:
        if Record:
            print("1", end="", file=HODCAresult)
            HODCAresult.flush()
        return(True)

    if Record :
        print("0", end="", file=HODCAresult)
        HODCAresult.flush()
    return(False)

def ParaHODCAsigma(path, T, W, S, Ord=2, begining=0, ending=0, Record=0):
    assert Ord >= 2, "The order O should be greater than one. For order equal to one, run DCA instead"
    (NodeVectors, nodesToGoThrough, begining, ending) = getNodeVectors(path, T, begining=begining, ending=ending, NonRedundantNodes=None, silent=1)
    NodeVectors = list(NodeVectors)
    NodeVectors = [[int(x) for x in row] for row in NodeVectors]

    PLAINTEXTS=[]
    for traceNumber in range(T):
        fpt = path / ("%04d.pt" % traceNumber)
        with open(fpt, "rb") as f:
            PLAINTEXTS += [f.read(1)[0]]

    AllSelVectors = []
    for key in range(256):
        keySelVect = []
        for pt in PLAINTEXTS:
            keySelVect.append(sbox[pt^^key]&0b1)
        AllSelVectors.append(keySelVect)
    SelectionVector = [SelectionFunction(pt) for pt in PLAINTEXTS]

    nmax = (len(NodeVectors)-W)//S

    itr = 0

    if Record:
        HODCAresult = open("resultParaHODCA.txt", "a")

    for n in tqdm(range(nmax)):
        #Win = SlidingWindow(NodeVectors, W, S, n, Type='List')
        Win = NodeVectors[n*S:n*S+W]
        for o in range(2,Ord+1):
            ExtWin = ExtXORTheWindow(Win,Ord)
            for Nv in ExtWin:
                Sv = SelectionVector
                itr += 1
                if T <= 256 or sigma_test(Nv, Sv, T=256, k=2.6125):  # deviation>21 1% chance
                    #k = 5.75 # for T=2048 deviation>130 1e-8 chance
                    k = 6.5 # for T=2048 deviation>146 1e-10 chance
                    if sigma_test(Nv, Sv, T=T, k=k):
                        matches = 0
                        for i in range(T):
                            matches += int(Nv[i] == Sv[i])
                        deviation = abs(matches - T/2)
                        sigma = T**0.5 / 2.0
                        print("itr", itr, "dev", deviation, "sigma", sigma, "ksigma", k*sigma, "T", T)
                        if Record:
                            print("1", end="", file=HODCAresult)
                            HODCAresult.flush()
                        return(True)

    if Record:
        print("0", end="", file=HODCAresult)
        HODCAresult.flush()
    return(False)

if __name__ == '__main__' and '__file__' in globals():
    parser = argparse.ArgumentParser(
        description='description to do later',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        'trace_dir', type=pathlib.Path,
        help="path to directory with trace/plaintext/ciphertext files"
    )

    parser.add_argument(
        '-T', '--trace-amount', type=int, default=85,
        help="Number of traces"
    )

    parser.add_argument(
        '-W', '--window-size', type=int, default=10,
        help="Window size"
    )

    parser.add_argument(
        '-S', '--step-size', type=int, default=5,
        help="Step size"
    )

    parser.add_argument(
        '-O', '--order', type=int, default=2,
        help="Degree of HODCA"
    )

    parser.add_argument(
        '-b', '--begining', type=int, default=0,
        help="Node to start HDDA at"
    )

    parser.add_argument(
        '-e', '--ending', type=int, default=0,
        help="Node to end HDDA at, if set as 0, then goes until the very last node"
    )

    parser.add_argument(
        '-r', '--record', type=int, default=0,
        help="Record the result in a file to parallelize"
    )

    parser.add_argument(
        '-s', '--sigma', type=int, default=0,
        help="to use the sigma version of HODCA instead"
    )

    args = parser.parse_args()

    if args.sigma:
        if(ParaHODCAsigma(args.trace_dir, args.trace_amount, args.window_size, args.step_size, args.order, args.begining, args.ending, args.record)):
            print("[SUCCESS] Differential Computation Analysis attack successfully retrived the key byte")
        else:
            print("[FAILLURE] Differential Computation Analysis attack did not retrieve the key byte")
    else :
        if(ParaHODCA(args.trace_dir, args.trace_amount, args.window_size, args.step_size, args.order, args.begining, args.ending, args.record)):
            print("[SUCCESS] Differential Computation Analysis attack successfully retrived the key byte")
        else:
            print("[FAILLURE] Differential Computation Analysis attack did not retrieve the key byte")
