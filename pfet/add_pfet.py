import shutil
import re
import sys

MAGIC_FILE = sys.argv[1]

shutil.copyfile(MAGIC_FILE, MAGIC_FILE + ".bak")

lines = []


ena_pos = None


def insert_powerfet():
    lines.append("use power_gate  power_gate_0 sky130_power_gate\n")
    lines.append("timestamp 1685868990\n")
    lines.append("transform -1 0 12200 0 -1 -600\n")
    lines.append("box -1428 -1134 11168 908\n")


flabel_vccd1 = False
strip_count = 0
with open(MAGIC_FILE, 'r') as f:
    for line in f:
        if re.match("^flabel metal4 .+ ena", line):
            x, y = line.split()[3:5]
            print (f"Found ena at {x} {y}")
            ena_pos = int(x), int(y)
        # test if this looks like a vccd1 power strip
        if re.match("^flabel metal4 .+ vccd1", line):
            print(f"Removing: {line.strip()}")
            flabel_vccd1 = True
            strip_count += 1
        elif flabel_vccd1:
            assert re.match("^port .+ power bidirectional", line)
            print(f"Removing: {line.strip()}")
            flabel_vccd1 = False
        else:
            if re.match("<< labels >>", line):
                insert_powerfet()
            lines.append(line)


with open(MAGIC_FILE, 'w') as f:
    f.write("".join(lines))

print(f"Removed total of {strip_count} vccd1 power strips")
