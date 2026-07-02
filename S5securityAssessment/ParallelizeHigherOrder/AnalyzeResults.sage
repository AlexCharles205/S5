import argparse
import pathlib

parser = argparse.ArgumentParser(
    description='description to do later',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument(
    '-A', '--attack', type=str, default="HDDA",
    help="to analyze HDDA or HODCA results"
)

parser.add_argument(
    '-r', '--result-file',
    type=pathlib.Path,
    default=None,
    help="path to result file to inerpret"
)

args = parser.parse_args()

if args.result_file == None :
    filename = "resultPara%s.txt" % args.attack
else :
    filename = args.result_file

with open(filename, "r") as f:
    content = f.read()

if "1" in content:
    print("%s succeeded" % args.attack)
else:
    print("%s failed" % args.attack)
