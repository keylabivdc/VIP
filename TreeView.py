#!/usr/bin/env python
#
#	TreeView.pl
#
#	This program will generate the phylogenetic tree in PNG format using ETE package.
#	#this script was developed for generating graphic result for phygo
#	
#	TreeView.pl <*.tree> <contig_num> <refgenome_num> <output>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved

import sys
from ete2 import Tree, NodeStyle, TreeStyle

if len(sys.argv) < 4:
	print "usage: TreeView.py <*.tree> <contig_num> <refgenome_num> <output>"
	sys.exit(-1)

contig_num = str(sys.argv[2])
#genus = str(sys.argv[3])
refgenome_num = str(sys.argv[3])
outfilename = str(sys.argv[4])
#print contig_num
tree = Tree(sys.argv[1])
ts = TreeStyle()
ts.scale = 120
nstyle = NodeStyle()
nstyle["shape"] = "sphere"
nstyle["size"] = 10
nstyle["fgcolor"] = "darkred"
#contig = tree.search_nodes(name=contig_num)[0]
contig = tree&contig_num
contig.set_style(nstyle)
#contig.add_features(label="CONTIG")
nstyle = NodeStyle()
nstyle["shape"] = "square"
nstyle["size"] = 10
nstyle["fgcolor"] = "aqua"
refgenome = tree&refgenome_num
refgenome.set_style(nstyle)
#refgenome.add_features(label="REFGENOME")
tree.render(outfilename, dpi=300, tree_style=ts)

