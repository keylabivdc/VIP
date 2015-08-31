#!/bin/bash
#
#	phygo.sh
#
#	This program phygo was a submodule of Virus Identification Pipeline.
#	It will automatically perform the de novo assembly and generate the phylogenetic tree.
#	
#	phygo.sh <reads fasta> <genus> <refgenome> <platform> <NGS>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved

if [ $# -lt 5 ]
then
	echo -e "Usage:\t$0 <reads fasta> <genus> <refgenome> <platform> <NGS> <kmer_start> <kmer_end> <kmer_step>"
	exit 65
fi

fasta=$1
genus=$2
refgenome=$3
platform=$4
NGS=$5
kmer_start=$6
kmer_end=$7
kmer_step=$8
##illumina run as paired
assembly.sh $fasta $genus $platform $kmer_start $kmer_end $kmer_step
#
#calibration
#output is temp.$genus.contigs
#echo -e "$(date)\t$0\tBegin to assemble unmatch reads"
getBestcontig.sh temp.$genus.contigs $genus $fasta
contig_length=`awk '(NR%2==0) {print length($0)}' temp.$genus.best.contig`
echo -e "$(date)\t$0\tThe best length of contig under $genus are : $contig_length"
avg_min_len=`prinseq-lite.pl -stats_len -fasta $fasta | grep mean | awk '{print$3}'`
min_contig_len=$(echo "scale=2;$avg_min_len * 1.5"|bc)
c=`echo "$contig_length > $min_contig_len"|bc`
if [ -s ./temp.$genus.best.contig ] && [ "$c" -gt "0" ]
then
	#output is temp.$genus.best.contig
	contig_num=`head -n 1 temp.$genus.best.contig | sed 's/>//'`
	get_refseq.pl $genus
	#output is temp.refseq.$genus.fasta
	#cat temp.refseq.$genus.fasta $refgenome > temp.$genus.backbone.seqs
	#sh MSA.sh temp.$genus.backbone.seqs temp.$genus.best.contig $genus
	MSA.sh temp.refseq.$genus.fasta $refgenome temp.$genus.best.contig $genus
	#TreeView.py "temp.$genus.backbone.seqs.add.tree" "$contig_num" "phygo.$genus.pdf"
	refgenome_num=`head -n 1 $refgenome.formatname | sed 's/>//'`
	echo ";" >> phygo.$genus.backbone.tree < /dev/null
	parse_tree.pl phygo.$genus.backbone.tree $contig_num $refgenome_num phygo.$genus.$NGS.png
	echo -e "$(date)\t$0\tThe phylogenetic analysis has been done"
else
	echo -e "$(date)\t$0\tNo valid reads or contigs"
	errorPrint.py "No valid reads or contigs under $genus to generate phylogenetic tree" phygo.$genus.$NGS.png
	#ps2png phygo.$genus.ps phygo.$genus.png
fi
