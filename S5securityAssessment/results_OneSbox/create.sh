#!/bin/bash -x
echo "Creating the circuits of the different countermeasures on the ToyAES\n\n"
pypy3 CountermeasureOnToyAES.py -a 1
echo "\n-------------------------------------------------------------------\n"

wboxkit.trace circuits/ToyAES.bin traces/ -T 128
wboxkit.trace circuits/ToyAES_ISW_2.bin traces/ -T 2048
wboxkit.trace circuits/ToyAES_ISW_3.bin traces/ -T 2048
wboxkit.trace circuits/ToyAES_MINQ.bin traces/ -T 8192
wboxkit.trace circuits/ToyAES_DS_2.bin traces/ -T 256
wboxkit.trace circuits/ToyAES_SEL_2_2.bin traces/ -T 8192
wboxkit.trace circuits/ToyAES_S5_3_3.bin traces/ -T 8192
wboxkit.trace circuits/ToyAES_ISWoDS_2_2.bin traces/ -T 8192
wboxkit.trace circuits/ToyAES_ISWoDS_3_3.bin traces/ -T 8192

