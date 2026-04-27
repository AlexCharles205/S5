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

def printResult(timeStart, timeEnd, Success, AttackName, ImplementationName):
    if Success :
        print("%s managed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
    else :
        print("%s failed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))


def mountAttack(degree,W,S,totalT,AttackName,ImplementationName,pathToToyAES):

    if AttackName == "ExactMatch":
        print("ExactMatch on %s:" % ImplementationName)
        start = time.time()
        Success = ExactMatching(pathToToyAES,totalT)
        end = time.time()
        printResult(start, end, Success, "ExactMatch", ImplementationName)


    if AttackName == "LDA":
        print("LDA on %s:" % ImplementationName)
        T=W+20
        assert totalT >= T, "You need %d traces to perform LDA" % T
        start = time.time()
        Success = LDA(pathToToyAES,T,W,S)
        end = time.time()
        printResult(start, end, Success, "LDA", ImplementationName)


    if AttackName == "FLDA":
        print("FLDA on %s:" % ImplementationName)
        T=2*W+20
        assert totalT >= T, "You need %d traces to perform FLDA" % T
        start = time.time()
        Success = FLDA(pathToToyAES,T,W,S)
        end = time.time()
        printResult(start, end, Success, "FLDA", ImplementationName)


    if AttackName == "DCA":
        print("DCA on %s:" % ImplementationName)
        start = time.time()
        Success = DCA(pathToToyAES,totalT)
        end = time.time()
        printResult(start, end, Success, "DCA", ImplementationName)


    if AttackName == "HDDA":
        print("HDDA of degree %d on %s:" % (degree, ImplementationName))
        start = time.time()
        Success = HDDA(pathToToyAES, totalT, W, S, Ord=degree)
        end = time.time()
        printResult(start, end, Success, "HDDA of degree %d" % degree, ImplementationName)


    if AttackName == "HODCA":
        print("HODCA of degree %d on %s:" % (degree, ImplementationName))
        start = time.time()
        Success = HODCA(pathToToyAES, totalT, W, S, Ord=degree)
        end = time.time()
        printResult(start, end, Success, "HODCA of degree %d" % degree, ImplementationName)



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
        '-T', '--trace-amount', type=int, default=1024,
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

    parser.add_argument(
        '-A', '--attack', type=str, default="FLDA",
        help="Name of the attack"
    )

    args = parser.parse_args()

    mountAttack(args.degree,args.window_size,args.step_size,args.trace_amount,args.attack,args.trace_dir.name,args.trace_dir)
