current_value = 0
highest = 0
total = 0
count = 0
inp = open("db/database.dat")
outp = open("outputs/python_a.csv", "a")

line = inp.readline()
while line:
    current_value = float(line)
    if current_value > highest:
        highest = current_value
    total = total + current_value
    count = count + 1
    line = inp.readline()
inp.close()
outp.writelines(f"{highest},{total},{count}")
outp.close()