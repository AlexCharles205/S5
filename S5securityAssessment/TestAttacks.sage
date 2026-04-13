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

log = open("logs.txt", "a")

def logprint(*args, **kwargs):
    print(*args, **kwargs)
    print(*args, **kwargs, file=log)
    log.flush()

def printResult(timeStart, timeEnd, Success, ExpectedToSucceed, AttackName, CountermeasureName):
    if ExpectedToSucceed:
        if Success :

            logprint("As expected, %s managed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
        else :
            logprint("/!\\ FAILLURE /!\\: %s failed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
    else :
        if Success :
            logprint("/!\\ FAILLURE /!\\: %s managed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))
        else :
            logprint("As expected, %s failed to break %s in %.5f seconds." % (AttackName, CountermeasureName, (timeEnd-timeStart)))

def TestOnClearToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on Clear ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, True, "Exact Match", "Clear ToyAES")

    logprint()
    logprint("LDA on Clear ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,40,20,5)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "Clear ToyAES")

    logprint()
    logprint("FLDA on Clear ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,60,20,5)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "Clear ToyAES")

    logprint()
    logprint("DCA on Clear ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "Clear ToyAES")


def TestOnISW2ToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on ISW_2 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISW_2 ToyAES")

    logprint()
    logprint("LDA on ISW_2 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,60,40,10)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "ISW_2 ToyAES")

    logprint()
    logprint("FLDA on ISW_2 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,100,40,10)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "ISW_2 ToyAES")

    logprint()
    logprint("DCA on ISW_2 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISW_2 ToyAES")

    logprint()
    logprint("HODCA on ISW_2 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, 1024, 40, 10, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, True, "HODCA", "ISW_2 ToyAES")

def TestOnISW3ToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on ISW_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISW_3 ToyAES")

    logprint()
    logprint("LDA on ISW_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,60,40,10)
    end = time.time()
    printResult(start, end, SuccessLDA, True, "LDA", "ISW_3 ToyAES")

    logprint()
    logprint("FLDA on ISW_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,100,40,10)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "ISW_3 ToyAES")

    logprint()
    logprint("DCA on ISW_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISW_3 ToyAES")

    logprint()
    logprint("HODCA on ISW_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, 1024, 40, 10, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "ISW_3 ToyAES")


def TestOnMINQToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on MINQ ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "MINQ ToyAES")

    logprint()
    logprint("LDA on MINQ ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,100,80,20)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "MINQ ToyAES")

    logprint()
    logprint("FLDA on MINQ ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,180,80,20)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "MINQ ToyAES")

    logprint()
    logprint("DCA on MINQ ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "MINQ ToyAES")

    logprint()
    logprint("HDDA on MINQ ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, 3290, 80, 20, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "MINQ ToyAES")

def TestOnDS_2ToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on DS ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "DS ToyAES")

    logprint()
    logprint("LDA on DS ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,60,40,10)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "DS ToyAES")

    logprint()
    logprint("FLDA on DS ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,100,40,10)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "DS ToyAES")

    logprint()
    logprint("DCA on DS ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, True, "DCA", "DS ToyAES")

def TestOnSEL_2_2ToyAES(pathToToyAES):
    logprint()
    logprint("ExactMatch on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "SEL_2_2 ToyAES")

    logprint()
    logprint("LDA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,120,100,25)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "SEL_2_2 ToyAES")

    logprint()
    logprint("FLDA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,220,100,25)
    end = time.time()
    printResult(start, end, SuccessFLDA, True, "FLDA", "SEL_2_2 ToyAES")

    logprint()
    logprint("DCA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "SEL_2_2 ToyAES")

    logprint()
    logprint("HDDA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, 5100, 100, 25, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "SEL_2_2 ToyAES")

    logprint()
    logprint("HODCA on SEL_2_2 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, 1024, 40, 10, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, True, "HODCA", "SEL_2_2 ToyAES")

def TestOnS5_3_3ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    logprint()
    logprint("ExactMatch on S5_3_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "S5_3_3 ToyAES")

    logprint()
    logprint("LDA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,120,100,25)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "S5_3_3 ToyAES")

    logprint()
    logprint("FLDA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,220,100,25)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "S5_3_3 ToyAES")

    logprint()
    logprint("DCA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "S5_3_3 ToyAES")

    logprint()
    logprint("HDDA on SEL ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, 5100, 100, 25, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "S5_3_3_2_2 ToyAES")

    logprint()
    logprint("HODCA on S5_3_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, 1024, 40, 10, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "S5_3_3 ToyAES")

def TestOnISWoDS_3_3ToyAES(W,S,totalT,ImplementationName,pathToToyAES):
    logprint()
    logprint("ExactMatch on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessExactMatch = ExactMatching(pathToToyAES,20)
    end = time.time()
    printResult(start, end, SuccessExactMatch, False, "Exact Match", "ISWoDS_3_3 ToyAES")

    logprint()
    logprint("LDA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessLDA = LDA(pathToToyAES,120,100,25)
    end = time.time()
    printResult(start, end, SuccessLDA, False, "LDA", "ISWoDS_3_3 ToyAES")

    logprint()
    logprint("FLDA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessFLDA = FLDA(pathToToyAES,220,100,25)
    end = time.time()
    printResult(start, end, SuccessFLDA, False, "FLDA", "ISWoDS_3_3 ToyAES")

    logprint()
    logprint("DCA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessDCA = DCA(pathToToyAES,40)
    end = time.time()
    printResult(start, end, SuccessDCA, False, "DCA", "ISWoDS_3_3 ToyAES")

    logprint()
    logprint("HDDA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessHDDA = HDDA(pathToToyAES, 5100, 100, 25, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHDDA, True, "HDDA", "ISWoDS_3_3 ToyAES")

    logprint()
    logprint("HODCA on ISWoDS_3_3 ToyAES:")
    start = time.time()
    SuccessHODCA = HODCA(pathToToyAES, 1024, 40, 10, Ord=2)
    end = time.time()
    printResult(start, end, SuccessHODCA, False, "HODCA", "ISWoDS_3_3 ToyAES")


def RunTestAttacks(pathToToyCircuits):
    logprint("Tests on a ToyAES with no protections")
    #To prove that every attack should work in the regular setting
    TestOnClearToyAES("Clear ToyAES",pathToToyCircuits / "ToyAES")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by S5 3 3")
    #To prove that against all the attacks of the litterature, S5 is thwarting them all
    TestOnS5_3_3ToyAES("S5 3 3 ToyAES",pathToToyCircuits / "ToyAES_S5_3_3")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by ISW_3oDS_3")
    #To prove that against all the attacks of the litterature, ISWoDS is thwarting them all
    TestOnISWoDS_3_3ToyAES("ISW_3oDS_3 ToyAES",pathToToyCircuits / "ToyAES_ISWoDS_3_3")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by ISW 2")
    #To prove that DCA doesnt work against ISW_2, but that HODCA_2 does
    #To prove that LDA attack works
    TestOnISW2ToyAES("ISW 2 ToyAES",pathToToyCircuits / "ToyAES_ISW_2")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by ISW 3")
    #To prove that HODCA_2 does ot work agains ISW_3
    TestOnISW3ToyAES("ISW 3 ToyAES",pathToToyCircuits / "ToyAES_ISW_3")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by MINQ")
    #To prove that LDA should not work against MINQ, but HDDA_2 does
    TestOnMINQToyAES("MINQ ToyAES",pathToToyCircuits / "ToyAES_MINQ")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by DS 2")
    #To prove that FLDA does not work against DS, and that DCA works
    TestOnDS_2ToyAES("DS 2 ToyAES",pathToToyCircuits / "ToyAES_DS_2")
    logprint("------------------------------------\n")

    logprint("Tests on a ToyAES protected by SEL 2 2")
    #To prove that HDDA, FLDA, HODCA works against SEL_2_2
    TestOnSEL_2_2ToyAES("SEL 2 2 ToyAES",pathToToyCircuits / "ToyAES_SEL_2_2")
    logprint("------------------------------------\n")


if __name__ == '__main__' and '__file__' in globals():
    parser = argparse.ArgumentParser(
        description='description to do later',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        'trace_dir', type=pathlib.Path,
        help="path to directory with trace/plaintext/ciphertext files"
    )

    args = parser.parse_args()

    RunTestAttacks(args.trace_dir)
