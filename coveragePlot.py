#!/usr/bin/python
#
#	coveragePlot.py
#
#	modified from https://github.com/chiulab/surpi	
#
#	This program will generate coverage map
#
#		coveragePlot.py <*.mapped> <*.report> <title genus> <NGS>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
import matplotlib
#import matplotlib.numerix as nx
matplotlib.use('Agg')
from pylab import *
from pylab import figure, show, legend
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
import sys, os

import re

def smart_truncate1(text, max_length=100, suffix='...'):
    """Returns a string of at most `max_length` characters, cutting
    only at word-boundaries. If the string was truncated, `suffix`
    will be appended.
    """

    if len(text) > max_length:
        pattern = r'^(.{0,%d}\S)\s.*' % (max_length-len(suffix)-1)
        return re.sub(pattern, r'\1' + suffix, text)
    else:
        return text

if len(sys.argv) < 3:
	print "usage: coveragePlot.py <*.mapped> <*.report> <title genus> <NGS>"
	sys.exit(-1)

dataFile = sys.argv[1]
report = sys.argv[2]
title = sys.argv[3]
ngs = sys.argv[4]

data = pd.read_table(dataFile,names=['X', 'Y'], header=None)

outputFile = "covplot."+title+"."+ngs+".png"


with open(report) as f:
    reportContent = f.readlines()

reportText = ""

for line in reportContent:
	stripped_line = line.rstrip('\r\n\t ')
	reportText = reportText + smart_truncate1(stripped_line, max_length=100, suffix='...') + "\n"

print "Loaded " + dataFile

hold(True)
   
fig=plt.figure(figsize=[8.5,4.5])   
ax = fig.add_subplot(111)    
fig.text(0.1,0.0,reportText, fontsize=9)   
color ='k-'    
plot(data['X'],data['Y'],color)    
xlabel("base position",fontsize=8)   
ylabel("fold coverage",fontsize=8) 
suptitle(title,fontsize=9)
xMin, xMax, yMin, yMax = min(data['X']),max(data['X']),min(data['Y']),max(data['Y'])    
yMax *= 1.1  
axis([xMin,xMax,yMin,yMax])   
gcf().subplots_adjust(bottom=0.60)   
plt.show()
savefig(outputFile)
