#!/usr/bin/python
#
#	blastn_position_depth.py
#
#	This program will extract the position and its depth information.
#
#		blastn_position_depth.py <blast file> <output file> <genome length>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05

usage = "blastn_position_depth.py <blast file> <output file> <genome length>"

import sys


blastFile = open(sys.argv[1], "r")
outputFile = open(sys.argv[2], "w")
gLength = int(sys.argv[3])
#    oLength = int(sys.argv[4])

genome = []

for base in range(gLength):
    genome.append(0)

for line in blastFile.readlines():
    data = line.split()
    oStart = int(data[6])
    oEnd = int(data[7])
    oLength = oEnd - oStart + 1
    gStart = min(int(data[8]),int(data[9]))
    gEnd = max(int(data[8]),int(data[9]))
    hitStart = max(0,(gStart-oStart+1))
    hitEnd = min(gLength,(gEnd+(oLength-oEnd)))
    for hit in range(hitStart,hitEnd+1):
    #for hit in range(gStart,gEnd):
	genome[hit-1]+=1

for entry in range(len(genome)):
    outputFile.write(str((entry)+1)+"\t")
    outputFile.write(str(genome[entry])+"\n")
