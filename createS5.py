from circkit.boolean import OptBooleanCircuit as BooleanCircuit
#import wboxkit
from binteger import Bin
import sys
from wboxkit.prng import NFSR, Pool
from wboxkit.ciphers.aes import BitAES
from wboxkit.serialize import RawSerializer
from S5 import S5
import os

key = b"abcdefghABCDEFGH"
plaintext = b"0123456789abcdef"

#ct = C.evaluate(Bin(plaintext).tuple)

nfsr = NFSR(
    taps=[[], [11], [50], [3, 107]],
    clocks_initial=100,
    clocks_per_step=1,
)
prng = Pool(prng=nfsr, n=256)


C = BooleanCircuit(name="AES")

key = b"abcdefghABCDEFGH"
plaintext = b"0123456789abcdef"

pt = C.add_inputs(128)
ct, k2 = BitAES(pt, Bin(key).tuple, rounds=2)
C.add_output(ct)
C.in_place_remove_unused_nodes()

C_S5 = S5(prng=prng, order=3, dummy=3).transform(C)
C_S5.in_place_remove_unused_nodes()

plaintext = os.urandom(16)
ct1 = C.evaluate(Bin(plaintext).tuple)
ct2 = C_S5.evaluate(Bin(plaintext).tuple)
assert ct1==ct2

"""
c=0
for i in range(100):
    plaintext = os.urandom(16)
    ct1 = C.evaluate(Bin(plaintext).tuple)
    ct2 = C_S5.evaluate(Bin(plaintext).tuple)
    if ct1==ct2:
        c+=1

print(c/100)
"""
# print(ct1)
# print(ct2)
# print(ct1==ct2)

C.print_stats()
C_S5.print_stats()
RawSerializer().serialize_to_file(C_S5, "circuits/aes2_S5.bin")
