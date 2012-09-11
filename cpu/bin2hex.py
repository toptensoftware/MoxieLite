import sys

# Open files
fin = open(sys.argv[1], "rb")
fout = open(sys.argv[2], "w")

# Skip
skip = 0
if len(sys.argv)>=4:
	skip = int(sys.argv[3], 0)

# Take
take = 0
if len(sys.argv)>=5:
	take = int(sys.argv[4], 0)
else:
	f.seek(0,2)
	take = f.tell() - skip

fin.seek(skip)

# Copy bytes
pos = 0
while take:
	byte = fin.read(2)
	if not byte:
		byte="\0\0"
	fout.write("%02x%02x\n" % (ord(byte[1]), ord(byte[0])))

	take -=2
	pos +=2

