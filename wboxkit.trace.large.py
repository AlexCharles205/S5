import sys
import ctypes
from ctypes import (
    cdll,
    c_uint64,
    c_void_p,
    c_char_p,
    c_int,
)

from pathlib import Path
import wboxkit.fastcircuit as FC
from wboxkit.attacks.trace import main

lib = cdll.LoadLibrary("./libfastcircuit.large.so")

lib.load_circuit.restype = c_void_p
lib.circuit_compute.argtypes = (c_void_p, c_char_p, c_char_p, c_char_p, c_int)
lib.set_seed.argtypes = c_uint64,

FC.lib = lib

if __name__ == '__main__':
    if sys.argv[0].endswith('.exe'):
        sys.argv[0] = sys.argv[0][:-4]
    sys.exit(main())
