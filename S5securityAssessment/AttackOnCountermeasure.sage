import sys
import os
import time
import pathlib
from circkit.boolean import OptBooleanCircuit as BooleanCircuit
from binteger import Bin
from wboxkit.prng import NFSR, Pool
from wboxkit.ciphers.aes import BitAES
from wboxkit.serialize import RawSerializer

load("./attacks/ExactMatch.sage")
load("./attacks/LDA.sage")
load("./attacks/DCA.sage")
load("./attacks/HDDA.sage")
load("./attacks/HODCA.sage")
load("./attacks/FLDA.sage")

#key = b"abcdefghABCDEFGH"
ToyAESkey=b"a"

def printResult(timeStart, timeEnd, Success, AttackName):
    if Success :
        print("/!\\ S5 FAILED /!\\: %s managed to break S5_2_2 in %.5f seconds." % (AttackName,(timeEnd-timeStart)))
    else :
        print("%s failed to break S5_2_2 in %.5f seconds." % (AttackName,(timeEnd-timeStart)))


def runAttacksOfFixedDegree(degree,W,S,totalT,ImplementationName,pathToToyAES):
    assert degree >= 1, "Degree should be greater or equal than 1"
    S5broken = 0

    if degree == 1:

        print("------------------Attacks of degree 1 on %s------------------" % ImplementationName)

        print()
        print("ExactMatch on %s:" % ImplementationName)
        start = time.time()
        Success = ExactMatching(pathToToyAES,totalT)
        end = time.time()
        printResult(start, end, Success, "ExactMatch")
        S5broken = S5broken or Success

        print()
        print("LDA on %s:" % ImplementationName)
        T=W+30
        assert totalT >= T, "You need %d traces to perform LDA" % T
        start = time.time()
        Success = LDA(pathToToyAES,T,W,S)
        end = time.time()
        printResult(start, end, Success, "LDA")
        S5broken = S5broken or Success

        print()
        print("FLDA on %s:" % ImplementationName)
        T=3*W+100
        assert totalT >= T, "You need %d traces to perform FLDA" % T
        start = time.time()
        Success = FLDA(pathToToyAES,T,W,S)
        end = time.time()
        printResult(start, end, Success, "FLDA")
        S5broken = S5broken or Success


        print()
        print("DCA on %s:" % ImplementationName)
        start = time.time()
        Success = DCA(pathToToyAES,totalT)
        end = time.time()
        printResult(start, end, Success, "DCA")
        S5broken = S5broken or Success

    else:
        print("------------------Attacks of degree %d on %s------------------" % (degree, ImplementationName))
        print()
        print("HDDA of degree %d on %s:" % (degree, ImplementationName))
        start = time.time()
        Success = HDDA(pathToToyAES, totalT, W, S, Ord=degree)
        end = time.time()
        printResult(start, end, Success, "HDDA of degree %d" % degree)
        S5broken = S5broken or Success

        print()
        print("HODCA of degree %d on %s:" % (degree, ImplementationName))
        start = time.time()
        Success = HODCA(pathToToyAES, totalT, W, S, Ord=degree)
        end = time.time()
        printResult(start, end, Success, "HODCA of degree %d" % degree)
        S5broken = S5broken or Success

    print("\n")
    if S5broken:
        print("/!\\ S5 FAILED /!\\: S5 failed to resist all of the degree %d attacks" % degree)
    else:
        print("SUCCESS: S5 resisted all the degree %d attacks" % degree)

    return(S5broken)


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
        '-T', '--trace-amount', type=int, default=40,
        help="Number of traces available"
    )

    parser.add_argument(
        '-W', '--window-size', type=int, default=20,
        help="Window size"
    )

    parser.add_argument(
        '-S', '--step-size', type=int, default=5,
        help="Step size"
    )

    parser.add_argument(
        '-D', '--degree', type=int, default=2,
        help="Degree of the Attacks"
    )

    args = parser.parse_args()

    S5brokenTotal = False
    startTotalTime = time.time()
    S5brokenTotal = S5brokenTotal | runAttacksOfFixedDegree(1,args.window_size, args.step_size, args.trace_amount, "ToyAES_%d_%d" % (args.degree, args.degree), args.trace_dir)
    endTotalTime = time.time()
    if args.degree > 1:
        print("\n")
        startTotalTime = time.time()
        #HDDA and HODCA of degree D encapsulate their lower degrees variants
        S5brokenTotal = S5brokenTotal | runAttacksOfFixedDegree(args.degree,args.window_size, args.step_size,args.trace_amount, "ToyAES_%d_%d" % (args.degree, args.degree), args.trace_dir)
        endTotalTime = time.time()
    if S5brokenTotal:
        print("/!\\ S5 FAILED /!\\: S5 failed to resist all of the tried attacks")
    else:
        print("SUCCESS: S5 resisted all the tried attacks")
