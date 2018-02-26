
# coding: utf-8
# (C) Júlio Barreto
# Replace commas with dots

data = open("result.csv", 'r')
lines = data.readlines()

for i in range(len(lines)):
	lines[i] = lines[i].replace(";",",")

to_write = "".join(lines)

with open("result.csv",'w') as result:
	result.write(to_write)

data.close()
