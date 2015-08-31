#!/usr/bin/python
#
#	errorPrint.sh
#
#	This program will generate the failed result for situation which can not generate phylogenetic tree.
#	
#	errorPrint.py <error msg> <outputfile>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
from pylab import *
from pylab import figure, show, legend
from matplotlib import pyplot as plt
import sys, os



if len(sys.argv) < 2:
	print "usage: errorPrint.py <error msg> <outputfile>"
	sys.exit(-1)

error_msg = sys.argv[1]
outputFile = sys.argv[2]
#genus = sys.argv[3]

fig=plt.figure(figsize=[8.5,4.5])
fig.text(0.1,0.5,error_msg, fontsize=11)
#plt.show()
savefig(outputFile)
