#!/bin/bash
#
#	assembly.sh
#
#	This program will perform the de novo assembly in Multiple-k mer method
#	
#	assembly.sh <reads fasta> <genus> <platform>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
if [ $# -lt 3 ]
then
	echo -e "Usage: $0 <reads fasta> <genus> <platform> <kmer_start> <kmer_end> <kmer_step>"
	exit 65
fi

####
fasta=$1
genus=$2
platform=$3
kmer_start=$4
kmer_end=$5
kmer_step=$6
####
#echo "#####################################################################################"
#echo "###kmer_start=$kmer_start###"
#echo "###kmer_end=$kmer_end"
#echo "###kmer_step=$kmer_step"
total_cores=$(grep processor /proc/cpuinfo | wc -l)
#total_ram=$(grep MemTotal /proc/meminfo | awk '{print $2}')
#total_ram_g=$(echo "scale=2;$total_ram / 1048576"|bc)
#total_ram=${total_ram_g}"G"
echo "$total_ram"
cur_dir=$(pwd)
###
echo -e "$(date)\t$0\tBegin to assemble unmatch reads"
avg_min_len=`prinseq-lite.pl -stats_len -fasta $fasta | grep mean | awk '{print$3}'`
min_contig_len=$(echo "scale=4;$avg_min_len * 1.5"|bc)
max_len=`prinseq-lite.pl -stats_len -fasta $fasta | grep max | awk '{print$3}'`
echo -e "$(date)\t$0\tmin_contig_len = $min_contig_len"
if [ "$max_len" -lt 40 ]
then
	#VelvetOptimiser.pl --s 7 --e "$max_len" -f "-short -fasta $fasta" -t $total_cores -k 'n50' -p ass_temp -o "-min_contig_lgth $min_contig_len"
	oases_pipeline.py -m "$kmer_start" -M "$max_len" -s 2 -o "$genus" -d "-fasta -short $fasta" -p "-min_trans_lgth $min_contig_len" -c
elif [ "$platform" = "illumina" ]
then
	#VelvetOptimiser.pl --s 7 --e 51 -f "-short -fasta $fasta" -t $total_cores -k 'n50' -p ass_temp -o "-min_contig_lgth $min_contig_len"
	oases_pipeline.py -m "$kmer_start" -M "$kmer_end" -s "$kmer_step" -o "$genus" -d "-fasta -shortPaired $fasta" -p "-min_trans_lgth $min_contig_len" -c
	#Trinity --seqType fa --max_memory $total_ram --single $fasta --CPU $total_cores --full_cleanup --run_as_paired
	#mv trinity_out_dir.Trinity.fasta temp.$genus.contigs.fasta
else
	#Trinity --seqType fa --max_memory $total_ram --single $fasta --CPU $total_cores --full_cleanup
	#mv trinity_out_dir.Trinity.fasta temp.$genus.contigs.fasta
	oases_pipeline.py -m "$kmer_start" -M "$kmer_end" -s "$kmer_step" -o "$genus" -d "-fasta -short $fasta" -p "-min_trans_lgth $min_contig_len" -c
fi
file=${genus}"Merged"
cd $file
mv transcripts.fa $cur_dir/temp.$genus.contigs
cd $cur_dir
echo -e "$(date)\t$0\tAssembly Done"

