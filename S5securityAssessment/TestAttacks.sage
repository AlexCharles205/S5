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

def printResult(timeStart, timeEnd, Success, ExpectedToSucceed, AttackName, CountermeasureName):
    if ExpectedToSucceed:
        if Success :
            print("As expected, %s managed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
        else :
            print("/!\\ FAILLURE /!\\: %s failed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
    else :
        if Success :
            print("/!\\ FAILLURE /!\\: %s managed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
        else :
            print("As expected, %s failed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))

def TestOnClearToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on Clear ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, True, "Exact Match", "Clear ToyAES")

    print()
    print("LDA on Clear ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "Clear ToyAES")

    print()
    print("FLDA on Clear ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "Clear ToyAES")

    print()
    print("DCA on Clear ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "Clear ToyAES")


def TestOnISW2ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on ISW_2 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISW_2 ToyAES")

    print()
    print("LDA on ISW_2 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "ISW_2 ToyAES")

    print()
    print("FLDA on ISW_2 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "ISW_2 ToyAES")

    print()
    print("DCA on ISW_2 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISW_2 ToyAES")

    print()
    print("HODCA on ISW_2 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, True, "HODCA", "ISW_2 ToyAES")

def TestOnISW3ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on ISW_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISW_3 ToyAES")

    print()
    print("LDA on ISW_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "ISW_3 ToyAES")

    print()
    print("FLDA on ISW_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "ISW_3 ToyAES")

    print()
    print("DCA on ISW_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISW_3 ToyAES")

    print()
    print("HODCA on ISW_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "ISW_3 ToyAES")


def TestOnMINQToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on MINQ ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "MINQ ToyAES")

    print()
    print("LDA on MINQ ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "MINQ ToyAES")

    print()
    print("FLDA on MINQ ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "MINQ ToyAES")

    print()
    print("DCA on MINQ ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "MINQ ToyAES")

    print()
    print("HDDA on MINQ ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "MINQ ToyAES")

def TestOnDS_2ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on DS ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "DS ToyAES")

    print()
    print("LDA on DS ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "DS ToyAES")

    print()
    print("FLDA on DS ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "DS ToyAES")

    print()
    print("DCA on DS ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "DS ToyAES")

def TestOnSEL_2_2ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "SEL_2_2 ToyAES")

    print()
    print("LDA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "SEL_2_2 ToyAES")

    print()
    print("FLDA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "SEL_2_2 ToyAES")

    print()
    print("DCA on SE_2_2L ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "SEL_2_2 ToyAES")

    print()
    print("HDDA on SEL ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "SEL ToyAES")

    print()
    print("HODCA on SEL ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, True, "HODCA", "SEL ToyAES")

def TestOnS5_3_3ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on S5_3_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "S5_3_3 ToyAES")

    print()
    print("LDA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "S5_3_3 ToyAES")

    print()
    print("FLDA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "S5_3_3 ToyAES")

    print()
    print("DCA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "S5_3_3 ToyAES")

    print()
    print("HODCA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "S5_3_3 ToyAES")

def TestOnISWoDS_3_3ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    print()
    print("ExactMatch on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISWoDS_3_3 ToyAES")

    print()
    print("LDA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "ISWoDS_3_3 ToyAES")

    print()
    print("FLDA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,totalT,W,S)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "ISWoDS_3_3 ToyAES")

    print()
    print("DCA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,totalT)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISWoDS_3_3 ToyAES")

    print()
    print("HODCA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, totalT, W, S, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "ISWoDS_3_3 ToyAES")


def RunTestAttacks(W,S,totalT,pathToToyCircuits):
    print("Tests on a ToyAES with no protections")
    #To prove that every attack should work in the regular setting
    TestOnClearToyAES(W,S,totalT,"Clear ToyAES",pathToToyCircuits / "ToyAES")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by ISW 2")
    #To prove that DCA doesnt work against ISW_2, but that HODCA_2 does
    #To prove that LDA attack works
    TestOnISW2ToyAES(W,S,totalT,"ISW ToyAES",pathToToyCircuits / "ToyAES_ISW_2")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by ISW 3")
    #To prove that HODCA_2 does ot work agains ISW_3
    TestOnISW3ToyAES(W,S,totalT,"ISW ToyAES",pathToToyCircuits / "ToyAES_ISW_3")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by MINQ")
    #To prove that LDA should not work against MINQ, but HDDA_2 does
    TestOnMINQToyAES(W,S,totalT,"MINQ ToyAES",pathToToyCircuits / "ToyAES_MINQ")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by DS 2")
    #To prove that FLDA does not work against DS, and that DCA works
    TestOnDS_2ToyAES(W,S,totalT,"SEL ToyAES",pathToToyCircuits / "ToyAES_DS_2")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by SEL 2 2")
    #To prove that HDDA, FLDA, HODCA works against SEL_2_2
    TestOnSEL_2_2ToyAES(W,S,totalT,"SEL ToyAES",pathToToyCircuits / "ToyAES_SEL_2_2")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by S5 3 3")
    #To prove that against all the attacks of the litterature, S5 is thwarting them all
    TestOnS5_3_3ToyAES(W,S,totalT,"SEL ToyAES",pathToToyCircuits / "ToyAES_S5_3_3")
    print("------------------------------------\n")

    print("Tests on a ToyAES protected by ISW_3oDS_3")
    #To prove that against all the attacks of the litterature, ISWoDS is thwarting them all
    TestOnISWoDS_3_3ToyAES(W,S,totalT,"SEL ToyAES",pathToToyCircuits / "ToyAES_ISWoDS_3_3")
    print("------------------------------------\n")


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

    args = parser.parse_args()

    RunTestAttacks(args.window_size, args.step_size, args.trace_amount, args.trace_dir)
