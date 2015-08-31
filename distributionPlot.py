#!/usr/bin/python
#
#	distributionPlot.py
#
#	This program will generate the distribution map.
#	
#	distributionPlot.py <distribution_file> <NGS> <reads or virus>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
import matplotlib
#import matplotlib.numerix as nx
matplotlib.use('Agg')
from pylab import *
from pylab import figure, show, legend
import matplotlib.pyplot as plt
#import numpy as np
import pandas as pd
import sys, os
import matplotlib as mtl

mtl.rcParams['font.size'] = 8.0

if len(sys.argv) < 3:
	print "usage: distributionPlot.py <distribution_file> <NGS> <reads or virus>"
	sys.exit(-1)

dataFile = sys.argv[1]
#report = sys.argv[2]
#title = sys.argv[3]
ngs = sys.argv[2]
file_type = str(sys.argv[3])
#outputFile = "covplot."+title+"."+ngs+".png"
if file_type == 'reads':
	outputFile = "reads_distribution"+"."+ngs+".png"
	ngs_title = "Reads Distribution"
	data = pd.read_table(dataFile,names=['X', 'Y'], header=None, skiprows=1)
	fig=plt.figure(figsize=[5,3.75])
	fig=plt.pie(data['Y'], labels=data['X'], autopct='%1.1f%%')
	title(ngs_title)
	#fig.
	plt.show()
	savefig(outputFile)
else:
	outputFile = "virus_distribution"+"."+ngs+".png"
	data = sys.argv[1]
	data = pd.read_table(data,names=['Genus', 'Coverage', 'Reads_Num'], header=None, skiprows=1, index_col=0)
	fig=plt.figure(figsize=[5,3.75])
	ax = fig.add_subplot(111)
	data['Coverage'].plot(kind='bar', width=0.2, color='red', ax=ax, position=1,legend=True)
	ax.legend(loc=2)
	#ax.set_xlabel('Genus')
	ax.set_xticklabels([1,2,3,4,5], rotation=10)
	ax.set_ylabel('Genome Coverage (%)')
	ax.set_ylim(0,110)
	ax.set_title('Top 5 virus distribution')
	ax2 = ax.twinx()
	data['Reads_Num'].plot(kind='bar', width=0.2, color='blue', ax=ax2, position=0, legend=True)
	ax2.legend(loc=1)
	ax2.set_ylabel('Reads Number classfied under genus')
	#fig.figsize=[5,3.75]
	plt.show()
	savefig(outputFile)
#data = pd.read_table(dataFile,names=['X', 'Y'], header=None, skiprows=1)
#fig=plt.figure(figsize=[5,3.75])
#fig=plt.pie(data['Y'], labels=data['X'], autopct='%1.1f%%')
#title(ngs_title)
#patches, texts, autotexts = fig
#texts.set_fontsize(9)
#plt.show()
#data.plot(kind='pie', figsize=(6, 6))
#savefig(outputFile)
