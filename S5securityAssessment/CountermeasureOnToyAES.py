from circkit.boolean import OptBooleanCircuit as BooleanCircuit
from binteger import Bin
import sys
from wboxkit.prng import NFSR, Pool
from wboxkit.serialize import RawSerializer
from wboxkit.masking import ISW, DumShuf, MINQ, QuadLin
from ToyAES import ToyAES
import os
import argparse

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from S5 import S5

key = b"abcdefghABCDEFGH"
ToyAESkey=b"a"

def countermeasureOnToyAES(countermeasure="S5",l=0,s=0,printStats=1):
    #S5 has l-1 linear shares and s slots
    #ISW uses l linear shares
    #DS uses s slots
    #MINQ is constant
    #SEL has l linear shares and is degree 2
    assert countermeasure in ["None", "S5", "ISW", "DS", "MINQ", "SEL", "ISWoDS"], "The countermeasure should be amongst \"S5\", \"ISW\", \"DS\", \"MINQ\", \"SEL\", \"ISWoDS\" or \"None\" for no countermeasure."

    #The Pseudo-Random Number Generator used to create fresh randomness in the circuit
    nfsr = NFSR(
        taps=[[], [1], [3], [5, 6], [15,12]],
        clocks_initial=200,
        clocks_per_step=1,
    )
    prng = Pool(prng=nfsr, n=500)

    #Creating a toy AES composed of one AES Sbox, add a key Byte, and one AES Sbox
    C = BooleanCircuit(name="ToyAES")
    pt = C.add_inputs(8)
    pt_supp = C.add_inputs(16)
    #We add more inputs for two reasons:
    #   o Having only 8 input bits leads to only 256 different inputs, and since
    #     a white-box implementation is stateless and deterministic, this results
    #     in only 256 different traces maximum. Therefore, attacks that require
    #     more cqn't operate as in the real-case scenario.
    #   o It allows to feed the PRNG with more inputs, generating more different
    #     possible pseudo-random bits, ensuring the freshness of the randomness
    #     which the countermeasures' security depends on.
    ct = ToyAES(pt, Bin(ToyAESkey))
    C.add_output(ct)

    C.in_place_remove_unused_nodes()

    #To generate the base ToyAES circuit:
    if countermeasure=="None":
        RawSerializer().serialize_to_file(C, "circuits/ToyAES.bin")
        C.print_stats()
        return True

    #To generate the ToyAES protected by S5:
    if countermeasure == "S5":
        #Verify the transformation validity
        C_S5_unencoded = S5(prng=prng, order=l, dummy=s, encoded_output=0).transform(C)
        C_S5_unencoded.in_place_remove_unused_nodes()
        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_S5_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        #Actual construction on which the attacks will be mounted on, the difference
        #is that the output remains encoded, as the output of the ToyAES exactly
        #corresponds to the output of the first Sbox of the first round of the AES.
        #Indeed, if left decoded, no protection is applied to it, and therefore
        #every attack succeeds, independently of the protection applied to toyAES.
        C_S5 = S5(prng=prng, order=l, dummy=s, decode_output=False).transform(C)
        C_S5.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_S5, "circuits/ToyAES_%s_%d_%d.bin" % (countermeasure,l,s))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s_%d stats:" % (countermeasure,l))
            C_S5.print_stats()

    if countermeasure == "ISW":
        #Verify the transformation validity
        C_ISW_unencoded = ISW(prng=prng, order=l, decode_output=True).transform(C)
        C_ISW_unencoded.in_place_remove_unused_nodes()
        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_ISW_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        C_ISW = ISW(prng=prng, order=l, decode_output=False).transform(C)
        C_ISW.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_ISW, "circuits/ToyAES_%s_%d.bin" % (countermeasure,l))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s_%d stats:" % (countermeasure,l))
            C_ISW.print_stats()

    if countermeasure == "DS":
        #Verify the transformation validity
        C_DS_unencoded = DumShuf(prng=prng, n_shares=s, decode_output=True).transform(C)
        C_DS_unencoded.in_place_remove_unused_nodes()
        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_DS_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        C_DS = DumShuf(prng=prng, n_shares=s, decode_output=False).transform(C)
        C_DS.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_DS, "circuits/ToyAES_%s_%d.bin" % (countermeasure,s))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s_%d stats:" % (countermeasure,s))
            C_DS.print_stats()

    if countermeasure == "MINQ":
        #Verify the transformation validity
        C_MINQ_unencoded = MINQ(prng=prng, decode_output=True).transform(C)
        C_MINQ_unencoded.in_place_remove_unused_nodes()
        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_MINQ_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        C_MINQ = MINQ(prng=prng, decode_output=False).transform(C)
        C_MINQ.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_MINQ, "circuits/ToyAES_%s.bin" % (countermeasure))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s stats:" % (countermeasure))
            C_MINQ.print_stats()

    if countermeasure == "SEL":
        #Verify the transformation validity
        C_SEL_unencoded = QuadLin(prng=prng, n_linear=l, decode_output=True).transform(C)
        C_SEL_unencoded.in_place_remove_unused_nodes()
        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_SEL_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        C_SEL = QuadLin(prng=prng, n_linear=l, decode_output=False).transform(C)
        C_SEL.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_SEL, "circuits/ToyAES_%s_%d_%d.bin" % (countermeasure,l,s))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s_%d_%d stats:" % (countermeasure,l,s))
            C_SEL.print_stats()

    if countermeasure == "ISWoDS": #TODO
        #Verify the transformation validity
        #Applying Dummy Shuffling to the base AES circuit
        C_DS = DumShuf(prng=prng, n_shares=s, decode_output=True).transform(C)
        C_DS.in_place_remove_unused_nodes()

        #Applying ISW to the Dummy Shuffled AES circuit
        C_ISWoDS_unencoded = ISW(prng=prng, order=l, decode_output=True).transform(C_DS)
        C_ISWoDS_unencoded.in_place_remove_unused_nodes()


        #Verifying that the protected implementation returns the same output
        for i in range(10):
            plaintext = os.urandom(3)
            ct1 = C.evaluate(Bin(plaintext).tuple)
            ct2 = C_ISWoDS_unencoded.evaluate(Bin(plaintext).tuple)
            assert ct1==ct2

        C_DS = DumShuf(prng=prng, n_shares=s, decode_output=False).transform(C)
        C_DS.in_place_remove_unused_nodes()

        #Applying ISW to the Dummy Shuffled AES circuit
        C_ISWoDS = ISW(prng=prng, order=l, decode_output=False).transform(C_DS)
        C_ISWoDS.in_place_remove_unused_nodes()

        #Saving the output circuit to a file, which can be used with wboxkit to generate traces
        RawSerializer().serialize_to_file(C_ISWoDS, "circuits/ToyAES_%s_%d_%d.bin" % (countermeasure,l,s))

        if printStats:
            #Printing circuit stats of the base AES and its protected version
            print("Regular ToyAES stats:")
            C.print_stats()

            # print("Unencoded S5 ToyAES stats:")
            # C_S5_unencoded.print_stats()

            print("ToyAES_%s_%d_%d stats:" % (countermeasure,l,s))
            C_ISWoDS.print_stats()


    return(True)


if __name__ == '__main__' and '__file__' in globals():
    parser = argparse.ArgumentParser(
        description='description to do later',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        '-l', '--linear-shares', type=int, default=0,
        help="Number of linear shares"
    )

    parser.add_argument(
        '-s', '--slots', type=int, default=0,
        help="Number of slots"
    )

    parser.add_argument(
        '-p', '--print-stats', type=int, default=1,
        help="Whether you want to prin the stats of the different implementations or not"
    )

    parser.add_argument(
        "-c", "--countermeasure", type=str, default="S5",
        help="What countermeasure to apply amongst \"S5\", \"ISW\", \"DS\", \"MINQ\", \"SEL\", \"ISWoDS\" or \"None\" for no countermeasure"
    )

    parser.add_argument(
        "-a", "--generate-all", type=int, default=0,
        help="To generate all the necessary circuits required for the TestAttacks.sage"
    )

    args = parser.parse_args()

    if args.generate_all:
        countermeasureOnToyAES("None", printStats=True)
        print()
        print()
        countermeasureOnToyAES("ISW", l=2, printStats=True)
        print()
        print()
        countermeasureOnToyAES("ISW", l=3, printStats=True)
        print()
        print()
        countermeasureOnToyAES("MINQ", printStats=True)
        print()
        print()
        countermeasureOnToyAES("DS", l=2, s=2, printStats=True)
        print()
        print()
        countermeasureOnToyAES("SEL", l=2, s=2, printStats=True)
        print()
        print()
        countermeasureOnToyAES("S5", l=3, s=3, printStats=True)
        print()
        print()
        countermeasureOnToyAES("ISWoDS", l=3, s=3, printStats=True)
        print()
    else:
        countermeasureOnToyAES(args.countermeasure, args.linear_shares, args.slots, printStats=args.print_stats)
