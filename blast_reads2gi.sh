#!/bin/bash
#
#	blast_reads2gi.sh
#
#	This program will make the most likely reference genome as the BLAST database for generating coverage maps
#
#		blast_reads2gi.sh <candidate.fa> <blastdb.fa> <genus> <outputfile>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05


if [ $# -lt 4 ]
then
	echo "Usage:<candidate.fa> <blastdb.fa> <genus> <outputfile>"
	exit
fi

###
candidate=$1
blastdb=$2
genus=$3
outputfile=$4
###

echo -e "$(date)\t$0\tBuilding the blastdb from $blastdb"
makeblastdb -in $blastdb -input_type fasta -dbtype nucl -parse_seqids -out temp.$genus.blastdb
echo -e "$(date)\t$0\tBlastn the $candidate against $blastdb"
echo -e "$0\tblastn -query $candidate -task blastn -reward 1 -penalty -1 -evalue 0.05 -db temp.$genus.blastdb -out $outputfile -outfmt 6 -max_target_seqs 1"
#blastn -query $candidate -task blastn -db temp.$genus.blastdb -out $outputfile -evalue 0.05 -outfmt 6 -max_target_seqs 1
blastn -query $candidate -task blastn -reward 1 -penalty -1 -evalue 0.05 -db temp.$genus.blastdb -out $outputfile -outfmt 6 -max_target_seqs 1
echo -e "$(date)\t$0\tBlastn done"
