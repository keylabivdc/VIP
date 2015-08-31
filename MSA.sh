#!/bin/bash
#
#	MSA.sh
#
#	This program will perform the multiple sequence aligment in UPGMA way for further constructing phylogenetic tree.
#	
#	MSA.sh <reference refseq_standard> <refgenome> <contigs fasta> <genus>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
if [ $# -lt 3 ]
then
	echo -e "usage: $0 <reference refseq_standard> <refgenome> <contigs fasta> <genus>"
	exit 65
fi

refseq=$1
refgenome=$2
contig=$3
genus=$4

trim_Ref.pl $refseq
trim_Ref.pl $refgenome
cat $refseq.formatname $refgenome.formatname > phygo.$genus.backbone.seqs
#trimRefname.pl $refseq
mafft --inputorder --adjustdirection --thread 8 --auto phygo.$genus.backbone.seqs > phygo.$genus.backbone
#mafft --inputorder --adjustdirection --thread 8 --addfragments $contig $refseq.backbone > $refseq.add
mafft --treeout --retree 2 --add $contig --adjustdirection --averagelinkage phygo.$genus.backbone > phygo.$genus.backbone.add.MSA
#clearcut --alignment --DNA --kimura --neighbor --in=$refseq.add --out=$refseq.add.tree

#phyml -i $refseq.add -d nt 
