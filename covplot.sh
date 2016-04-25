#!/bin/bash
#
#
#	covplot.sh
#
#	This program covplot was a submodule of Virus Identification Pipeline.
#	It will automatically choose the most likely reference genome. The reference genome will be further subject to BLAST alignment for coverage maps.
#	
#	covplot.sh <annotated BOWTIE file> <annotated RAPSearch file> <NGS> <mode> <platform>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
if [ $# -lt 7 ]
then
	echo -e "$0\tUsage: <annotated BOWTIE file> <annotated RAPSearch file> <NGS> <mode> <platform> <kmer_start> <kmer_end> <kmer_step>"
	exit
fi

bowtie_file=$1
rapsearch_file=$2
NGS=$3
mode=$4
platform=$5
kmer_start=$6
kmer_end=$7
kmer_step=$8
address=`pwd`

#perl $address/create_tmp_table.pl -f sam $bowtie_file
#perl $address/create_tmp_table.pl -f blast $rapsearch_file
if [ "$mode" = "sense" ]
then
	create_tmp_table.pl -f blast $rapsearch_file
	create_tmp_table.pl -f sam $bowtie_file
#
#format qseqid specis genus family
#
	echo -e "$(date)\t$0\tdone creating $bowtie_file.tempsorted && $rapsearch_file.tempsorted"
	sed 's/ /_/g' $bowtie_file > temp.$bowtie_file.nospace
	sed 's/ /_/g' $rapsearch_file > temp.$rapsearch_file.nospace
	awk -F "\t" '{print$4}' $bowtie_file.tempsorted | sort -u -k1,1 > temp.$bowtie_file.uniq.genus
	awk -F "\t" '{print$4}' $rapsearch_file.tempsorted | sort -u -k1,1 > temp.$rapsearch_file.uniq.genus
	cat temp.$bowtie_file.uniq.genus temp.$rapsearch_file.uniq.genus | sort -u -k1,1 | sed 's/ /_/g' | sed /^[[:space:]]*$/d > temp.all.$NGS.uniq.genus
	echo -e "$(date)\t$0\tdone creating temp.all.$NGS.uniq.genus"
	
	#while read genus
	for genus in `cat temp.all.$NGS.uniq.genus` 
	do
		echo -e "$(date)\t$0\tParsing genus: $genus"
		echo -e "$(date)\t$0\tCreating temp file for $genus"
		mkdir temp.$genus.$NGS
		START1=$(date +%s)
		##将所有reads放到对应的genus文件下并合并
		egrep "$genus" temp.$bowtie_file.nospace | awk '{print">"$1"\n"$10}' > ./temp.$genus.$NGS/temp.$genus.bowtie.fa
		egrep "$genus" temp.$rapsearch_file.nospace | awk '{print">"$1"\n"$13}' > ./temp.$genus.$NGS/temp.$genus.rapsearch.fa
		##获得前200名gi
		#egrep "$genus" temp.$bowtie_file.nospace | awk '{print$3}' | sed 's/gi|//g' | sed 's/|//g' | sort | uniq -c | sort -k1,1 -r -g | awk '{print$2}' | head -n 200 > ./temp.$genus.$NGS/temp.$genus.gilist  
		egrep "$genus" temp.$bowtie_file.nospace | awk '{print$3}' | sed 's/gi|//g' | sed 's/|//g' | awk '{a[$1]++}END{for (i in a) print i" "a[i]}' | sort -r -k2,2 -n > ./temp.$genus.$NGS/temp.$genus.gi_time
		awk '{print$1}' ./temp.$genus.$NGS/temp.$genus.gi_time | head -n 100 > ./temp.$genus.$NGS/temp.$genus.gilist  				
		if [ -s ./temp.$genus.$NGS/temp.$genus.gilist ]
		then
			echo -e "$(date)\t$0\tDownloading fasta records based on temp.$genus.gilist"
			#perl $address/get_genbankfasta.pl -i ./temp.$genus.$NGS/temp.$genus.gilist > ./temp.$genus.$NGS/temp.$genus.gilist.fa
			get_genbankfasta.pl -i ./temp.$genus.$NGS/temp.$genus.gilist > ./temp.$genus.$NGS/temp.$genus.gilist.fa
			##从前200名中选择具备名字complete genome or complete sequence
			#perl $address/get_complete.pl ./temp.$genus.$NGS/temp.$genus.gilist.fa
			get_complete.pl ./temp.$genus.$NGS/temp.$genus.gilist.fa
			#exit 65
			echo -e "$(date)\t$0\tReference sequence has been achieved: temp.$genus.gilist.fa.blastdb.fasta"
			cd temp.$genus.$NGS
			##将比对结果中reads进行blast，比对对象为temp.$genus.gilist.fa.blastdb.fasta
			cat temp.$genus.bowtie.fa temp.$genus.rapsearch.fa > temp.$genus.fa
			#sh $address/blast_reads2gi.sh temp.$genus.fa temp.$genus.gilist.fa.blastdb.fasta $genus temp.$genus.$NGS.blastn
			blast_reads2gi.sh temp.$genus.fa temp.$genus.gilist.fa.blastdb.fasta $genus temp.$genus.$NGS.blastn
			##画图
			echo -e "$(date)\t$0\tPlot blast output against reference"
			#sh $address/plot_blast.sh temp.$genus.$NGS.blastn temp.$genus.gilist.fa.blastdb.fasta $genus $NGS
			plot_blast.sh temp.$genus.$NGS.blastn temp.$genus.gilist.fa.blastdb.fasta $genus $NGS
			phygo.sh temp.$genus.fa $genus temp.$genus.gilist.fa.blastdb.fasta $platform $NGS $kmer_start $kmer_end $kmer_step
			cd ..
		else
			echo -e "$(date)\t$0\tNo valid nucl reference based on temp.$genus.gilist"
			sed '/$genus/d' temp.all.$NGS.uniq.genus > temp.all.$NGS.uniq.genus.tmp
			mv temp.all.$NGS.uniq.genus.tmp temp.all.$NGS.uniq.genus
		fi
	done		
		#done < temp.all.$NGS.uniq.genus
elif [ "$mode" = "fast" ]
then
	create_tmp_table.pl -f sam $bowtie_file
	echo -e "$(date)\t$0\tdone creating $bowtie_file.tempsorted && $rapsearch_file.tempsorted"
	sed 's/ /_/g' $bowtie_file > temp.$bowtie_file.nospace
	awk -F "\t" '{print$4}' $bowtie_file.tempsorted | sort -u -k1,1 > temp.$bowtie_file.uniq.genus
	cat temp.$bowtie_file.uniq.genus | sort -u -k1,1 | sed 's/ /_/g' | sed /^[[:space:]]*$/d > temp.all.$NGS.uniq.genus
	echo -e "$(date)\t$0\tdone creating temp.all.$NGS.uniq.genus"
	for genus in `cat temp.all.$NGS.uniq.genus`
	do
		echo -e "$(date)\t$0\tParsing genus: $genus"
		echo -e "$(date)\t$0\tCreating temp file for $genus"
		mkdir temp.$genus.$NGS
		START1=$(date +%s)
		##将所有reads放到对应的genus文件下并合并
		egrep "$genus" temp.$bowtie_file.nospace | awk '{print">"$1"\n"$10}' > ./temp.$genus.$NGS/temp.$genus.bowtie.fa
		#egrep "$genus" temp.$rapsearch_file.nospace | awk '{print">"$1"\n"$13}' > ./temp.$genus.$NGS/temp.$genus.rapsearch.fa
		##获得前200名gi
		#egrep "$genus" temp.$bowtie_file.nospace | awk '{print$3}' | sed 's/gi|//g' | sed 's/|//g' | sort | uniq -c | sort -k1,1 -r -g | awk '{print$2}' | head -n 200 > ./temp.$genus.$NGS/temp.$genus.gilist  
		egrep "$genus" temp.$bowtie_file.nospace | awk '{print$3}' | sed 's/gi|//g' | sed 's/|//g' | awk '{a[$1]++}END{for (i in a) print i" "a[i]}' | sort -r -k2,2 -n > ./temp.$genus.$NGS/temp.$genus.gi_time
		awk '{print$1}' ./temp.$genus.$NGS/temp.$genus.gi_time | head -n 100 > ./temp.$genus.$NGS/temp.$genus.gilist  	
		##获得前100名gi对应的fasta格式
		if [ -s ./temp.$genus.$NGS/temp.$genus.gilist ]
		then
			echo -e "$(date)\t$0\tDownloading fasta records based on temp.$genus.gilist"
			#perl $address/get_genbankfasta.pl -i ./temp.$genus.$NGS/temp.$genus.gilist > ./temp.$genus.$NGS/temp.$genus.gilist.fa
			get_genbankfasta.pl -i ./temp.$genus.$NGS/temp.$genus.gilist > ./temp.$genus.$NGS/temp.$genus.gilist.fa
			##从前200名中选择具备名字complete genome or complete sequence
			#perl $address/get_complete.pl ./temp.$genus.$NGS/temp.$genus.gilist.fa
			get_complete.pl ./temp.$genus.$NGS/temp.$genus.gilist.fa
			#exit 65
			echo -e "$(date)\t$0\tReference sequence has been achieved: temp.$genus.gilist.fa.blastdb.fasta"
			cd temp.$genus.$NGS
			##将比对结果中reads进行blast，比对对象为temp.$genus.gilist.fa.blastdb.fasta
			#cat temp.$genus.bowtie.fa temp.$genus.rapsearch.fa > temp.$genus.fa
			cat temp.$genus.bowtie.fa > temp.$genus.fa
			#sh $address/blast_reads2gi.sh temp.$genus.fa temp.$genus.gilist.fa.blastdb.fasta $genus temp.$genus.$NGS.blastn
			blast_reads2gi.sh temp.$genus.fa temp.$genus.gilist.fa.blastdb.fasta $genus temp.$genus.$NGS.blastn
			##画图
			echo -e "$(date)\t$0\tPlot blast output against reference"
			#sh $address/plot_blast.sh temp.$genus.$NGS.blastn temp.$genus.gilist.fa.blastdb.fasta $genus $NGS
			plot_blast.sh temp.$genus.$NGS.blastn temp.$genus.gilist.fa.blastdb.fasta $genus $NGS
			#phygo.sh temp.$genus.fa $genus temp.$genus.gilist.fa.blastdb.fasta $platform $NGS
			phygo.sh temp.$genus.fa $genus temp.$genus.gilist.fa.blastdb.fasta $platform $NGS $kmer_start $kmer_end $kmer_step			
			cd ..
		else
			echo -e "$(date)\t$0\tNo valid nucl reference based on temp.$genus.gilist"
			sed '/$genus/d' temp.all.$NGS.uniq.genus > temp.all.$NGS.uniq.genus.tmp
			mv temp.all.$NGS.uniq.genus.tmp temp.all.$NGS.uniq.genus
		fi			
	done
fi
