filename = "resultParaHDDA.txt"

with open(filename, "r") as f:
    content = f.read()

if "1" in content:
    print("HDDA succeeded")
else:
    print("HDDA failed")
