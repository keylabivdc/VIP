#!/bin/bash
#
#	get_fulllength.sh
#
#	Quick guide:
#	Restore the full length of reads being soft-cut during local alignment
#
#		get_fulllength.sh <parent_file fastq> <query_file> <sam/blast>
#

### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
if [ $# -lt 3 ]
then
	echo -e "$0\tusage:<parent_file fastq> <query_file> <sam/blast>"
	exit 65
fi

#
parentfile=$1
queryfile=$2
format=$3
#
echo -e "$(date)\t$0\t####$0 begin####"
#awk '{print$1}' $queryfile | sort -k1,1 | sed '/#/d' > $queryfile.header
#echo -e "$(date)\t$0\t####$queryfile.header generated####"
echo -e "$(date)\t$0\t####Start getting the original fastq from parentfile: $parentfile####"
awk '(NR%4==1) {sub(/@/,"");printf("%s\t",$0)} (NR%4==2) {printf("%s\t", $0)} (NR%4==0) {printf("%s\n",$0)}' "$parentfile" | sort -k1,1 | awk '{print$1"\t"$2"\t"$3}' > "$parentfile.tmp"
#awk '{print$1}' $queryfile.header | grep
echo -e "$(date)\t$0\t####$parentfile.tmp generated####"
if [ "$format" = "sam" ]
then
	echo -e "$(date)\t$0\t####The format of $queryfile is sam####"
	awk '{print$1}' $queryfile | sort -k1,1 > $queryfile.header
	sort -k1,1 $queryfile > $queryfile.sorted
	awk 'NR==FNR{a[$1]=$1"\t"$2"\t"$3}NR!=FNR{if(a[$1])print(a[$1])}' "$parentfile.tmp" "$queryfile.header" > "$queryfile.header.fulllength"
	sort -k1,1 "$queryfile.header.fulllength" | awk -F "\t" '{print $2"\t"$3}' > $queryfile.tmp.cut10-11
	cut -f1-9 $queryfile.sorted > $queryfile.tmp.cut1-9
	cut -f12- $queryfile.sorted > $queryfile.tmp.cut12
	paste $queryfile.tmp.cut1-9 $queryfile.tmp.cut10-11 $queryfile.tmp.cut12 > $queryfile.addseq
else
	echo -e "$(date)\t$0\t####The format of $queryfile is blast####"
	awk '{print$1}' $queryfile | sort -k1,1 | sed '/#/d' > $queryfile.header
	sort -k1,1 $queryfile | sed '/#/d' > $queryfile.sorted
	awk 'NR==FNR{a[$1]=$1"\t"$2"\t"$3}NR!=FNR{if(a[$1])print(a[$1])}' "$parentfile.tmp" "$queryfile.header" > "$queryfile.header.fulllength"
	cut -f2- "$queryfile.header.fulllength" > "$queryfile.tmp.cut2"
	#paste $queryfile $queryfile.tmp.seqinfo > $queryfile.prot.original
	paste $queryfile.sorted $queryfile.tmp.cut2 > $queryfile.addseq
fi

rm -f $queryfile.header
rm -f $parentfile.tmp
rm -f $queryfile.sorted
rm -f $queryfile.header.fulllength
rm -f $queryfile.tmp.*
