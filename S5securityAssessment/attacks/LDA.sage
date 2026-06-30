import argparse
import pathlib
import os
import sys
import io

load("./attacks/SelectionAndNodeVectors.sage")
load("./attacks/SlidingWindow.sage")

def LDA(path, T, W, S):
    assert T>=W+20, "The number of traces T should be greater or equal than W+20"
    (NodeVectors, SelectionVector) = SelectionAndNodeVectors(path, T)
    SelectionVECTOR = vector(GF(2), SelectionVector)

    nmax = (len(NodeVectors)-W)//S
    for n in range(nmax):
        Win = SlidingWindow(NodeVectors, W, S, n, Type='Matrix')
        try :
            Win.solve_right(SelectionVECTOR)
            return(True)
        except :
            pass
    Win = SlidingWindow(NodeVectors, W, S, -1, Type='Matrix')
    try :
        Win.solve_right(SelectionVECTOR)
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
#     if(LDA(args.trace_dir, args.trace_amount, args.window_size, args.step_size)):
#         print("[SUCCESS] Linear Decoding Analysis attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Linear Decoding Analysis did not retrieve the key byte")
