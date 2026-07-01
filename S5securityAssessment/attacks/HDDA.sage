import argparse
import pathlib
import os
import sys
import io
from functools import reduce
from itertools import combinations, product
from math import factorial as fac
from tqdm import tqdm

F2 = GF(2)
F2tab = F2(0), F2(1)

load("./attacks/SelectionAndNodeVectors.sage")
load("./attacks/SlidingWindow.sage")


def RequiredAmountOfTracesHDDA(W, Ord):
    neededTraces=50 #Supplementary traces to avoid false positives with probability 1/2^50
    for o in range(2,Ord+1):
        neededTraces+=binomial(W,Ord)
    return(W+neededTraces)

def ANDlists(L1,L2):
    return([a*b for a, b in zip(L1, L2)])

def ExtANDTheWindow(W, Ord):
    ExtW = []

    # linear vecors
    for vec in W:
        ExtW.append([F2tab[v] for v in vec])

    # product vectors
    products = []
    for combSize in range(2,Ord+1):
        for comb in combinations(ExtW, combSize):
            andvec = reduce(ANDlists, comb)
            products.append(andvec)

    ExtW = products + ExtW

    # constant vector
    ExtW.append([F2tab[1]] * len(W[0]))
    return(ExtW)

def HDDA(path, T, W, S, Ord=2):
    #assert Ord >= 2, "The order O should be greater than one. For order equal to one, run LDA instead"

    RequiredTraces = RequiredAmountOfTracesHDDA(W, Ord)

    assert T>=RequiredTraces, "The number of traces T should be greater or equal than %d" % RequiredTraces
    T = RequiredTraces
    (NodeVectors, SelectionVector) = SelectionAndNodeVectors(path, T)
    SelectionVECTOR = vector(GF(2), SelectionVector)

    nmax = (len(NodeVectors)-W)//S
    for n in tqdm(range(nmax)):
        Win = SlidingWindow(NodeVectors, W, S, n, Type='List')
        for o in range(2,Ord+1):
            ExtWin = Matrix(GF(2), ExtANDTheWindow(Win,o))
            try :
                ExtWin.solve_left(SelectionVECTOR)
                # print("Extended window is %d lines and %d lines" % (ExtWin.nrows(), ExtWin.ncols()))
                # print("the seletion vector is %d long" % len(SelectionVECTOR))
                # print("the solution of the solve_left is %d long" % len(ExtWin.solve_left(SelectionVECTOR)))
                # print("rank of ext win rank is %d" % ExtWin.rank())
                # print("window %d out of %d" % (n, nmax))
                return(True)
            except :
                pass

    Win = SlidingWindow(NodeVectors, W, S, -1, Type='List')
    for o in range(2,Ord+1):
        ExtWin = Matrix(GF(2), ExtANDTheWindow(Win,o))
        try :
            ExtWin.solve_left(SelectionVECTOR)
            return(True)
        except :
            pass
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
#         help="Degree of HDDA"
#     )
#
#     args = parser.parse_args()
#
#     if(HDDA(args.trace_dir, args.trace_amount, args.window_size, args.step_size, args.order)):
#         print("[SUCCESS] Higher Degree Decoding Analysis attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Higher Degree Decoding Analysis did not retrieve the key byte")
