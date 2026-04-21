import argparse
import pathlib
import os
import sys
import io

load("./attacks/SelectionAndNodeVectors.sage")
load("./attacks/SlidingWindow.sage")

def AbsCorr(v1,v2,T):
    matches = 0
    for i in range(T):
        matches += v1[i] ^^ v2[i] ^^ 1
    if matches > T/2 :
        return((matches - (T/2))/(T/2))
    else :
        return((T - matches - (T/2))/(T/2))

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

def HODCA(path, T, W, S, Ord=2):
    assert Ord >= 2, "The order O should be greater than one. For order equal to one, run DCA instead"
    (NodeVectors, SelectionVector, AllSelVectors) = SelectionAndNodeVectors(path, T, fullSelvectors = 1)
    BestAbsCorOfSv = [0 for _ in range(256)]

    nmax = (len(NodeVectors)-W)//S
    for n in range(nmax):
        Win = SlidingWindow(NodeVectors, W, S, n, Type='List')
        for o in range(2,Ord+1):
            ExtWin = ExtXORTheWindow(Win,Ord)
            for Nv in ExtWin:
                for i in range (256):
                    Corr = AbsCorr(Nv, AllSelVectors[i], T)
                    if Corr > BestAbsCorOfSv[i]:
                        BestAbsCorOfSv[i] = Corr

    if AllSelVectors[maxCorIdx(BestAbsCorOfSv)] == SelectionVector:
        return(True)
    return(False)

# if __name__ == '__main__' and '__file__' in globals():
#     parser = argparse.ArgumentParser(
#         description='description to do later',
#         formatter_class=argparse.ArgumentDefaultsHelpFormatter,
#     )
#
#     parser.add_argument(
#         'trace_dir', type=pathlib.Path,
#         help="path to directory with trace/plaintext/ciphertext files"
#     )
#
#     parser.add_argument(
#         '-T', '--trace-amount', type=int, default=85,
#         help="Number of traces"
#     )
#
#     parser.add_argument(
#         '-W', '--window-size', type=int, default=10,
#         help="Window size"
#     )
#
#     parser.add_argument(
#         '-S', '--step-size', type=int, default=5,
#         help="Step size"
#     )
#
#     parser.add_argument(
#         '-O', '--order', type=int, default=2,
#         help="Degree of HODCA"
#     )
#
#     args = parser.parse_args()
#
#     if(HODCA(args.trace_dir, args.trace_amount, args.window_size, args.step_size, args.order)):
#         print("[SUCCESS] Differential Computation Analysis attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Differential Computation Analysis attack did not retrieve the key byte")
