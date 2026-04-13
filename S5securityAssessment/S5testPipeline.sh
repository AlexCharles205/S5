#!/bin/bash -x
echo "Creating the circuits of the different countermeasures on the ToyAES\n\n" > logstest.txt
python3 CountermeasureOnToyAES.py -a 1 >> logs.txt
echo "\n-------------------------------------------------------------------\n" >> logstest.txt

wboxkit.trace circuits/ToyAES.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_ISW_2.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_ISW_3.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_MINQ.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_DS_2.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_SEL_2_2.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_S5_3_3.bin traces/ -T 1024
wboxkit.trace circuits/ToyAES_ISWoDS_3_3.bin traces/ -T 1024

sage TestAttacks.sage traces/
