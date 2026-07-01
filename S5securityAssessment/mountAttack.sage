import sys
import os
import time
import pathlib
import argparse
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


def logprint(*args, **kwargs):
    print(*args, **kwargs)
    print(*args, **kwargs, file=log)
    log.flush()

def printLogResult(timeStart, timeEnd, AttackSuccess, ExpectedSuccess, AttackName, ImplementationName):
    if AttackSuccess :
        if ExpectedSuccess :
            logprint("As expected, %s managed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
        else :
            logprint("/!\\ FAILED /!\\: %s managed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
    else :
        if ExpectedSuccess :
            logprint("/!\\ FAILED /!\\: %s failed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
        else :
            logprint("As expected, %s failed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
    return(1)

def printResult(timeStart, timeEnd, Success, AttackName, ImplementationName):
    if Success :
        print("%s managed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))
    else :
        print("%s failed to break %s in %.5f seconds." % (AttackName, ImplementationName, (timeEnd-timeStart)))


def performAttack(degree,W,S,skip_init,totalT,AttackName,ImplementationName,pathToToyAES):

    if AttackName == "ExactMatch":
        return(ExactMatching(pathToToyAES,totalT))

    elif AttackName == "LDA":
        T=W+20
        assert totalT >= T, "You need %d traces to perform LDA" % T
        return(LDA(pathToToyAES,T,W,S))

    elif AttackName == "FLDA":
        T=2*W+20
        assert totalT >= T, "You need %d traces to perform FLDA" % T
        return(FLDA(pathToToyAES,T,W,S))

    elif AttackName == "DCA":
        return(DCA(pathToToyAES,totalT))

    elif AttackName == "HDDA":
        return(HDDA(pathToToyAES, totalT, W, S, skip_init, Ord=degree))

    elif AttackName == "HODCA":
        return(HODCAsigma(pathToToyAES, totalT, W, S, skip_init, Ord=degree))

    else :
        print("\"%s\" is not a valid attack name. Please chose between \"ExactMatch\", \"LDA\", \"HDDA\", \"DCA\", \"HODCA\", \"FLDA\"" % AttackName)
        return(0)

def mountAttack(degree,W,S,skip_init,totalT,AttackName,ImplementationName,pathToToyAES):
    start = time.time()
    Success = performAttack(degree,W,S,skip_init,totalT,AttackName,ImplementationName,pathToToyAES)
    end = time.time()
    printResult(start, end, Success, AttackName, ImplementationName)
    return(1)

def logTestAttack(degree,W,S,skip_init,totalT,AttackName,ImplementationName,pathToToyAES,ExpectedSuccess):
    start = time.time()
    Success = performAttack(degree,W,S,skip_init,totalT,AttackName,ImplementationName,pathToToyAES)
    end = time.time()
    printLogResult(start, end, Success, ExpectedSuccess, AttackName, ImplementationName)
    return(1)


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
        '-I', '--skip-init', type=int, default=0,
        help="Skip initialization #bits in the trace (PRNG, etc.). For (HO)DCA mainly."
    )

    parser.add_argument(
        '-D', '--degree', type=int, default=2,
        help="Degree of the Attacks"
    )

    parser.add_argument(
        '-A', '--attack', type=str, default="FLDA",
        help="Name of the attack"
    )

    parser.add_argument(
        '--ExpectedSuccess', type=int, default=2,
        help="If equal to 1 or 0, it will verify whether the attack succeeds or not and register it in the logs"
    )

    parser.add_argument(
        "--logFile",
        nargs="?",
        const="logs.txt",
        default=None,
        help="Create a log file (default: logs.txt)"
    )

    args = parser.parse_args()

    if args.ExpectedSuccess in (0, 1):

        if args.logFile is None or args.logFile == "logs.txt":
            log_path = pathlib.Path("logs.txt")
        else:
            log_path = pathlib.Path(args.logFile)

        log_path.parent.mkdir(parents=True, exist_ok=True)

        log = log_path.open("a")

        logTestAttack(args.degree,args.window_size,args.step_size,args.skip_init,args.trace_amount,args.attack,args.trace_dir.name,args.trace_dir,args.ExpectedSuccess)
    else :
        mountAttack(args.degree,args.window_size,args.step_size,args.trace_amount,args.attack,args.trace_dir.name,args.trace_dir)
