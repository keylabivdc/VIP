#!/bin/bash
#
#	plot_blast.sh
#
#	This program will parse the blastn output and generate coverage map
#
#		plot_blast.sh <blastn output> <reference_fasta> <genus> <NGS>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
#

if [ $# -lt 4 ]; then
    echo "Usage: <blastn output> <reference_fasta> <genus> <NGS>"    
    exit
fi
##
##
blastresult=$1
ref=$2
genus=$3
NGS=$4
##
refname=`head -n 1 $ref | sed 's/>//g'`
gi=`head -n 1 $ref | sed 's/^>gi|//' | sed 's/|.*//g'`
species=`head -n 1 $ref | sed 's/^>gi|.*|//' | sed 's/^ //'`
##
curdir=`pwd`
#let "reflength = `sed '/>/d' $2 | awk 'BEGIN{FS=""}{for(i=1;i<=NF;i++)c++}END{print c}'`"
reflength=`prinseq-lite.pl -stats_len -fasta $ref | grep max | awk '{print$3}'`
echo -e "$(date)\t$0\tLength of reference sequence: $reflength bp"
echo -e "$(date)\t$0\tpython $curdir/mapPerfectBLASTtoGenome.py $blastresult $blastresult.mapped $reflength"
#python /media/root/2ee9c614-1a8e-7d4a-bb3b-e0122db34edc/VIP_current/mapPerfectBLASTtoGenome.py $blastresult $blastresult.mapped $reflength
blastn_position_depth.py $blastresult $blastresult.mapped $reflength
##获得文件 第一列是位置 第二列是深度
#coverage计算
#首先获得多少个位置出现了
#let "notcoverage = `awk '{print$2}' $blastresult.mapped | grep -c "0"`"
#把10也算了
echo -e "$(date)\t$0\tCoverage calculation"
let "notcoverage = `awk '{print$2}' $blastresult.mapped | grep -c "^0$"`"
let "coverage = $reflength - $notcoverage"
#$(echo "scale=2;(1/2) * $b * $h"|bc) 
echo -e "$(date)\t$0\tNumber of bp covered : $coverage bp"
#let "coverage_percent = 'scale=6;100*$coverage/$reflength | bc'"
coverage_percent=$(echo "scale=4;$coverage / $reflength * 100"|bc)
echo -e "$(date)\t$0\t%Coverage = $coverage_percent"
#depth计算
echo -e "$(date)\t$0\tDepth calculation"
let "totaldepth = `awk '{print$2}' $blastresult.mapped | awk '{sum += $1} END {print sum}'`"
depth_avg=$(echo "scale=4;$totaldepth / $reflength * 100"|bc)
echo -e "$(date)\t$0\tAverage depth of coverage (x) = $depth_avg" 
#reads count for blast
echo -e "$(date)\t$0\tReads count for blast"
let "reads_count = `awk '{print$1}' $blastresult | sort -u | wc -l`"
##reads_num
total_num=$(wc -l temp.$genus.fa | awk '{print $1}')
let "reads_num=$total_num/2"
#let "reads_num = `wc -l temp.$genus.fa`"
#echo "$reads_count"
#生成报告
echo "Coverage information of Genus: $genus" > $blastresult.report
echo "reference is $refname" >> $blastresult.report
echo "Details:" >> $blastresult.report
echo "Length of reference sequence: $reflength bp" >> $blastresult.report
echo "%Coverage = $coverage_percent" >> $blastresult.report
echo "Average depth of coverage (x) = $depth_avg" >> $blastresult.report
echo "Number of reads: $reads_num" >> $blastresult.report
echo "Number of reads hit: $reads_count" >> $blastresult.report
echo -e "$genus\t$coverage_percent" >> ../$NGS.coverage
#echo -e "Species\tGenus\tGI\t%Coverage\tReads_hit\tAverage depth of coverage" > ../$NGS.coverage_report/temp.$NGS.covreport
echo -e "$species\t$genus\t$gi\t$coverage_percent\t$reads_count\t$reads_num\t$depth_avg" >> ../$NGS.report/temp.$NGS.covreport
#生成一个每个genus所对应的coverage的表格
#图形化
#python /media/root/2ee9c614-1a8e-7d4a-bb3b-e0122db34edc/VIP_current/coveragePlot.py $blastresult.mapped $blastresult.report $genus
coveragePlot.py $blastresult.mapped $blastresult.report $genus $NGS
#ps2png $blastresult.ps $blastresult.png
