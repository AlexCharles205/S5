import argparse
import pathlib
import os
import sys
import io

load("./attacks/SelectionAndNodeVectors.sage")
load("./attacks/SlidingWindow.sage")

def GetFiltIdx(Vect, FiltBy=0):
    Idx = []
    for i in range(len(Vect)):
        if Vect[i]==FiltBy:
            Idx.append(i)
    return(Idx)

def FiltVector(Vect, FiltIdx):
    return ([Vect[idx] for idx in FiltIdx])

def FiltWindowByNodeVector(W, Idx):
    assert Idx<len(W[0]), "The filtering index is not contained in the window"
    FiltW = []
    FiltIdx = GetFiltIdx(W[Idx])
    for i in range(len(W)):
        if i != Idx:
            FiltW.append(FiltVector(W[i], FiltIdx))
    return(FiltW)

def WindowIsTooFiltered(FiltWin, minFilt=20):
    #print("%d?>%d" % (FiltWin.ncols(), FiltWin.nrows() + minFilt))
    return(FiltWin.ncols() < (FiltWin.nrows() + minFilt))

def FLDA(path, T, W, S):
    assert T>=2*W+20, "The number of traces T should be greater or equal than 2*W+20"
    (NodeVectors, SelectionVector) = SelectionAndNodeVectors(path, T)

    skip = 0
    nmax = (len(NodeVectors)-W)//S
    for n in range(nmax):
        Win = SlidingWindow(NodeVectors, W, S, n, Type='List')
        for NodVecToFilterIdx in range(W):
            FiltWin = Matrix(GF(2),FiltWindowByNodeVector(Win, NodVecToFilterIdx))
            if not WindowIsTooFiltered(FiltWin):
                FiltSelectionVector = vector(GF(2),FiltVector(SelectionVector, GetFiltIdx(Win[NodVecToFilterIdx])))
                try :
                    FiltWin.solve_left(FiltSelectionVector)
                    return(True)
                except :
                    pass
            else:
                skip += 1


    Win = SlidingWindow(NodeVectors, W, S, -1, Type='List')
    for NodVecToFilterIdx in range(W):
        FiltWin = Matrix(GF(2),FiltWindowByNodeVector(Win, NodVecToFilterIdx)).transpose()
        FiltSelectionVector = vector(GF(2),FiltVector(SelectionVector, GetFiltIdx(Win[NodVecToFilterIdx])))
        try :
            FiltWin.solve_right(FiltSelectionVector)
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
#         '-T', '--trace-amount', type=int, default=40,
#         help="Number of traces"
#     )
#
#     parser.add_argument(
#         '-W', '--window-size', type=int, default=20,
#         help="Window size"
#     )
#
#     parser.add_argument(
#         '-S', '--step-size', type=int, default=5,
#         help="Step size"
#     )
#
#     args = parser.parse_args()
#
#     if(FLDA(args.trace_dir, args.trace_amount, args.window_size, args.step_size)):
#         print("[SUCCESS] Filtered Linear Decoding Analysis attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Filtered Linear Decoding Analysis did not retrieve the key byte")
