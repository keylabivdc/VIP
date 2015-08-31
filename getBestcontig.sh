#!/bin/bash
#
#	getBestcontig.sh
#
#	This script will install VIP and its dependencies. It has been tested with Ubuntu 14.04 LTS.
#
#	quick guide:
#
#	getBestcontig.sh <contigs> <genus> <fasta>
#
#	This file was developed to find the best contig (longest) after calibration.
#	input:
#		qseqid sseqid qseq length
#
#	the length stands the alignment length
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
### Copyright (C) 2014 Yang Li - All Rights Reserved

if [ $# -lt 3 ]
then
	echo "<contigs> <genus> <fasta>"
	exit 65
fi

contig=$1
genus=$2
fasta=$3

echo -e "$(date)\t$0\tBegin to get the best contig"
cat $contig $fasta > temp.all.$genus.fasta
blastn -query temp.all.$genus.fasta -task blastn -evalue 0.05 -db temp.$genus.blastdb -out phygo.temp.$genus.calibration -outfmt "6 qseqid sseqid qseq length" -max_target_seqs 1
#formatcontig.pl phygo.temp.$genus.calibration
#输出文件是 $contig.best
sort -k4,4 -r -n phygo.temp.$genus.calibration | head -n 1 | sed 's/-//g' | awk '{print">"$1"\n"$3}' > temp.$genus.best.contig
echo -e "$(date)\t$0\ttemp.$genus.best.contig achieved"
rm -f temp.all.$genus.fasta.best
rm -f temp.all.$genus.fasta
