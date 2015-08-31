#!/bin/bash   
#
#
#	table_generator.sh
#
#	Quick guide:
#	It will parse the annotated sam/blast file and perform classfication based on species/genus/family
#
#		table_generator.sh <annotated file> <sam/blast>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
#
if [ $# -lt 2 ]
then
	echo "Usage: <annotated file> <sam/blast>" 
  	exit
fi

###
inputfile=$1
file_type=$2
###
scriptname=${0##*/}

#perl create_tmp_table.pl -f $file_type $inputfile
create_tmp_table.pl -f $file_type $inputfile
echo -e "$(date)\t$scriptname\tdone creating $inputfile.tempsorted"
#mkdir ./result/tax/
##################将tempsortedfile进行解析###########
echo -e "#######Prepare to generate Columntable########"
echo -e "Species\tGenus\tFamily" > $inputfile.header
sort -k5,5 $inputfile.tempsorted | sed 's/\t/,/g' | sort -u -t, -k 5,5 | sed 's/,/\t/g' | awk -F "\t" '{print$3,"\t"$4,"\t"$5}' > $inputfile.uniq.columntable
cat $inputfile.header $inputfile.uniq.columntable > $inputfile.counttable_temp;
sed '/^ /d' $inputfile.counttable_temp > $inputfile.counttable_column; #get rid of null line
#################分类学文件#######################
#perl taxonomy_classfication.pl $inputfile.tempsorted
taxonomy_classfication.pl $inputfile.tempsorted
########################################
#$inputfile.tempsorted.gi.counttable
#$inputfile.tempsorted.species.counttable
#$inputfile.tempsorted.genus.counttable
#$inputfile.tempsorted.family.counttable
############################################
#sort -k 1,1 $inputfile.tempsorted.species.counttable > ./result/tax/$inputfile.species.counttable
#sort -k 1,1 $inputfile.tempsorted.genus.counttable > ./result/tax/$inputfile.genus.counttable
#sort -k 1,1 $inputfile.tempsorted.family.counttable > ./result/tax/$inputfile.family.counttable
#sort -k 1,1 $inputfile.tempsorted.gi.counttable > ./result/tax/$inputfile.gi.counttable
sort -k 1,1 $inputfile.tempsorted.species.counttable > $inputfile.species.counttable
sort -k 1,1 $inputfile.tempsorted.genus.counttable > $inputfile.genus.counttable
sort -k 1,1 $inputfile.tempsorted.family.counttable > $inputfile.family.counttable
sort -k 1,1 $inputfile.tempsorted.gi.counttable > $inputfile.gi.counttable
####################################3
rm -f $inputfile.tempsorted
rm -f $inputfile.header
rm -f $inputfile.uniq.columntable
rm -f $inputfile.tempsorted.species.counttable
rm -f $inputfile.tempsorted.genus.counttable
rm -f $inputfile.tempsorted.family.counttable
rm -f $inputfile.tempsorted.gi.counttable
