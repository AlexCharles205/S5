#!/bin/bash -x
output=S5maskVerif.ml
result=result.txt
python3 SNIS5verification.py -l "${1:-5}" -s "${2:-5}" -IO "${3:-both}" -Mat "${4:-low}" -dum "${5:-none}" -srnd "${6:y}" > "$output"
python3 VerifyS5.py > testS5.py
python3 testS5.py
../tools/maskverif/maskverif/maskverif < S5maskVerif.ml &> "$result"
cat result.txt | tail -2 | head -1
