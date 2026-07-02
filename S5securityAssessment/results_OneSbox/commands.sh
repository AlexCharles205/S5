#!/bin/bash -x
echo "Creating the circuits of the different countermeasures on the ToyAES\n\n"
# python3 CountermeasureOnToyAES.py -a 1
echo "\n-------------------------------------------------------------------\n"

# wboxkit.trace circuits/ToyAES.bin traces/ -T 128
# wboxkit.trace circuits/ToyAES_ISW_2.bin traces/ -T 2048
# wboxkit.trace circuits/ToyAES_ISW_3.bin traces/ -T 2048
# wboxkit.trace circuits/ToyAES_MINQ.bin traces/ -T 8192
# wboxkit.trace circuits/ToyAES_DS_2.bin traces/ -T 256
# wboxkit.trace circuits/ToyAES_SEL_2_2.bin traces/ -T 8192
# wboxkit.trace circuits/ToyAES_S5_3_3.bin traces/ -T 8192
# wboxkit.trace circuits/ToyAES_ISWoDS_3_3.bin traces/ -T 1024

#Regular ToyAES stats:
#ToyAES(OptBooleanCircuit): 
#   |    24 inputs,    8 outputs,    342 nodes
#   | XOR:174 (50.88%), AND:78 (22.81%), NOT:66 (19.30%), INPUT:24 (7.02%)
echo 
date
echo 24 inputs,    8 outputs,    342 nodes
echo "Performing tests on Clear ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_Clear/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 40 -W 20 -S 5 traces/ToyAES --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_Clear/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 80 -W 20 -S 5 traces/ToyAES --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_Clear/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 40 traces/ToyAES --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_Clear/DCA.txt"


#ToyAES_ISW_2 stats:
#ToyAES_ISW(OptBooleanCircuit): 
#   |    24 inputs,   24 outputs,   6348 nodes
#   | XOR:3529 (55.59%), AND:2048 (32.26%), NOT:747 (11.77%), INPUT:24 (0.38%)
echo 
date
echo 24 inputs,   24 outputs,   6348 nodes
echo "Performing tests on ISW_2 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_ISW_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISW_2/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 60 -W 40 -S 10 traces/ToyAES_ISW_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_ISW_2/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 120 -W 40 -S 10 traces/ToyAES_ISW_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_ISW_2/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 40 traces/ToyAES_ISW_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISW_2/DCA.txt"


#ToyAES_ISW_3 stats:
#ToyAES_ISW(OptBooleanCircuit): 
#   |    24 inputs,   32 outputs,   8030 nodes
#   | XOR:4671 (58.17%), AND:2580 (32.13%), NOT:755 (9.40%), INPUT:24 (0.30%)
echo 
date
echo 24 inputs,   32 outputs,   8030 nodes
echo "Performing tests on ISW_3 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_ISW_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISW_3/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 60 -W 40 -S 10 traces/ToyAES_ISW_3 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_ISW_3/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 120 -W 40 -S 10 traces/ToyAES_ISW_3 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_ISW_3/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 40 traces/ToyAES_ISW_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISW_3/DCA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 2048 -W 40 -S 10 traces/ToyAES_ISW_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISW_3/HODCA.txt"


#ToyAES_MINQ stats:
#ToyAES_MINQ(OptBooleanCircuit): 
#   |    24 inputs,   24 outputs,  13374 nodes
#   | XOR:8540 (63.86%), AND:4044 (30.24%), NOT:766 (5.73%), INPUT:24 (0.18%)
echo 
date
echo 24 inputs,   24 outputs,  13374 nodes
echo "Performing tests on MINQ ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_MINQ --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_MINQ/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 100 -W 80 -S 20 traces/ToyAES_MINQ --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_MINQ/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 240 -W 100 -S 25 traces/ToyAES_MINQ --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_MINQ/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 200 traces/ToyAES_MINQ --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_MINQ/DCA.txt"
sage mountAttack.sage -- -A "HDDA" -T 5100 -W 100 -S 25 traces/ToyAES_MINQ --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_MINQ/HDDA.txt"


#ToyAES_DS_2 stats:
#ToyAES_DumShuf(OptBooleanCircuit): 
#   |    24 inputs,   16 outputs,   5122 nodes
#   | XOR:2666 (52.05%), AND:1612 (31.47%), NOT:820 (16.01%), INPUT:24 (0.47%)
echo 
date
echo 24 inputs,   16 outputs,   5122 nodes
echo "Performing tests on DS_2 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_DS_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_DS_2/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 60 -W 40 -S 10 traces/ToyAES_DS_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_DS_2/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 240 -W 100 -S 25 traces/ToyAES_DS_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_DS_2/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 200 traces/ToyAES_DS_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_DS_2/DCA.txt"


#ToyAES_SEL_2_2 stats:
#ToyAES_QuadLin(OptBooleanCircuit): 
#   |    24 inputs,   32 outputs,  16215 nodes
#   | XOR:10597 (65.35%), AND:4828 (29.77%), NOT:766 (4.72%), INPUT:24 (0.15%)
echo 
date
echo 24 inputs,   32 outputs,  16215 nodes
echo "Performing tests on SEL_2_2 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_SEL_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_SEL_2_2/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 120 -W 100 -S 25 traces/ToyAES_SEL_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_SEL_2_2/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 360 -W 160 -S 40 traces/ToyAES_SEL_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_SEL_2_2/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 1000 traces/ToyAES_SEL_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_SEL_2_2/DCA.txt"
sage mountAttack.sage -- -A "HDDA" -T 5100 -W 100 -S 25 traces/ToyAES_SEL_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_SEL_2_2/HDDA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 1024 -W 40 -S 10 traces/ToyAES_SEL_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_SEL_2_2/HODCA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 2048 -W 40 -S 10 traces/ToyAES_SEL_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_SEL_2_2/HODCA.txt"
# too slow
# sage mountAttack.sage -- -A "HODCA" -I 500 -T 5000 -W 80 -S 10 traces/ToyAES_SEL_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_SEL_2_2/HODCA.txt"


#ToyAES_ISWoDS_2_2 stats:
#ToyAES_DumShuf_ISW(OptBooleanCircuit): 
echo 
date
echo "Performing tests on ISWoDS_2_2 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_2_2/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 120 -W 100 -S 25 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_2_2/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 240 -W 100 -S 25 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_2_2/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 1000 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_2_2/DCA.txt"
# needs a specific variant of the attack to actually break it
sage mountAttack.sage -- -A "HDDA" -T 5100 -W 100 -S 25 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_2_2/HDDA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 1024 -W 40 -S 10 traces/ToyAES_ISWoDS_2_2 --ExpectedSuccess 1 --logFile "ourLogs/ToyAES_ISWoDS_2_2/HODCA.txt"


#ToyAES_S5_3 stats:
#ToyAES_S5(OptBooleanCircuit): 
#   |    24 inputs,   40 outputs,  12046 nodes
#   | XOR:7699 (63.91%), AND:3561 (29.56%), NOT:762 (6.33%), INPUT:24 (0.20%)
echo 
date
echo 24 inputs,   40 outputs,  12046 nodes
echo "Performing tests on S5_3_3 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 120 -W 100 -S 25 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 240 -W 100 -S 25 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 1000 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/DCA.txt"
sage mountAttack.sage -- -A "HDDA" -T 5100 -W 100 -S 25 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/HDDA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 1024 -W 40 -S 10 traces/ToyAES_S5_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_S5_3_3/HODCA.txt"


#ToyAES_ISWoDS_3_3 stats:
#ToyAES_DumShuf_ISW(OptBooleanCircuit): 
#   |    24 inputs,   96 outputs,  93530 nodes
#   | XOR:60800 (65.01%), AND:31138 (33.29%), NOT:1568 (1.68%), INPUT:24 (0.03%)
echo 
date
echo 24 inputs,   96 outputs,  93530 nodes
echo "Performing tests on ISWoDS_3_3 ToyAES\n"
sage mountAttack.sage -- -A "ExactMatch" -T 40 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/ExactMatching.txt"
sage mountAttack.sage -- -A "LDA" -T 120 -W 100 -S 25 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/LDA.txt"
sage mountAttack.sage -- -A "FLDA" -T 240 -W 100 -S 25 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/FLDA.txt"
sage mountAttack.sage -- -A "DCA" -T 1000 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/DCA.txt"
sage mountAttack.sage -- -A "HDDA" -T 5100 -W 100 -S 25 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/HDDA.txt"
sage mountAttack.sage -- -A "HODCA" -I 500 -T 1024 -W 40 -S 10 traces/ToyAES_ISWoDS_3_3 --ExpectedSuccess 0 --logFile "ourLogs/ToyAES_ISWoDS_3_3/HODCA.txt"