from circkit.boolean import OptBooleanCircuit as BooleanCircuit
from binteger import Bin
import sys
from wboxkit.prng import NFSR, Pool
from wboxkit.serialize import RawSerializer
from ToyAES import ToyAES
import os
import argparse

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from S5 import S5

key = b"abcdefghABCDEFGH"
ToyAESkey=b"a"

def createS5onToyAES(l,s,printStats=1):

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
    pt_supp = C.add_inputs(8)
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
    if (l==0)|(s==0):
        RawSerializer().serialize_to_file(C, "circuits/ToyAES.bin")
        return True

    #Verify the transformation validity
    C_S5_unencoded = S5(prng=prng, order=l, dummy=s, encoded_output=0).transform(C)
    C_S5_unencoded.in_place_remove_unused_nodes()

    #Verifying that the protected implementation returns the same output
    for i in range(10):
        plaintext = os.urandom(2)
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
    RawSerializer().serialize_to_file(C_S5, "circuits/ToyAES_S5_%d_%d.bin" % (l,s))

    if printStats:
        #Printing circuit stats of the base AES and its protected version
        print("Regular ToyAES stats:")
        C.print_stats()

        # print("Unencoded S5 ToyAES stats:")
        # C_S5_unencoded.print_stats()

        print("ToyAES_S5_%d_%d stats:" % (l,s))
        C_S5.print_stats()

    return(True)


if __name__ == '__main__' and '__file__' in globals():
    parser = argparse.ArgumentParser(
        description='description to do later',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        '-l', '--linear-shares', type=int, default=3,
        help="Number of linear shares"
    )

    parser.add_argument(
        '-s', '--slots', type=int, default=3,
        help="Number of slots"
    )

    parser.add_argument(
        '-p', '--print-stats', type=int, default=1,
        help="Whether you want to prin the stats of the different implementations or not"
    )

    args = parser.parse_args()

    createS5onToyAES(args.linear_shares, args.slots, printStats=args.print_stats)
