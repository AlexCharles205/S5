import argparse
import pathlib
import os
import sys
import io

load("./attacks/SelectionAndNodeVectors.sage")

def ExactMatching(path, T):
    (NodeVectors, SelectionVector) = SelectionAndNodeVectors(path, T)
    for Nv in NodeVectors:
        if Nv==SelectionVector:
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
#     if(ExactMatching(args.trace_dir, args.trace_amount)):
#         print("[SUCCESS] Exact Matching attack successfully retrived the key byte")
#     else:
#         print("[FAILLURE] Exact Matching attack did not retrieve the key byte")
