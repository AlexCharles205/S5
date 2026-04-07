import argparse
import pathlib
import os
import sys
import io

load("./attacks/SelectionAndNodeVectors.sage")

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


def DCA(path, T):
    (NodeVectors, SelectionVector, AllSelVectors) = SelectionAndNodeVectors(path, T, fullSelvectors = 1)
    BestAbsCorOfSv = [0 for _ in range(256)]

    for Nv in NodeVectors:
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
#         '-T', '--trace-amount', type=int, default=30,
#         help="Number of traces"
#     )
#
#     args = parser.parse_args()
#
#     if(DCA(args.trace_dir, args.trace_amount)):
#         print("[SUCCESS] Differential Computation Analysis attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Differential Computation Analysis attack did not retrieve the key byte")
