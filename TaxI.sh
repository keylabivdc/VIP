#!/bin/bash
#
#
#	TaxI.sh
#
#	Quick guide:
#	The scientific information will be appending at the end of each record.
#
#		TaxI.sh <nucl_file/prot_file> <sam/blast> <nucl/prot> <cores> <tax_dir>
#

### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
#
scriptname=${0##*/}
if [ $# -lt 5 ]
then
	echo "Usage: $scriptname <nucl_file/prot_file> <sam/blast> <nucl/prot> <cores> <tax_dir>"
	exit 65
fi

########
result=$1
filetype=$2
datatype=$3
total_cores=$4
tax_dir=$5
########

if [ "$filetype" = "blast" ]
then
	sed -i '/^#/d' $result
	echo -e "$(date)\tParsing $result"
	echo -e "$(date)\tThe filetype of $result is $filetype"
	echo -e "perl taxonomy_lookup.pl $result blast prot $total_cores $tax_dir"
	#perl taxonomy_lookup.pl $result blast prot $total_cores $tax_dir
	taxonomy_lookup.pl $result blast prot $total_cores $tax_dir
	table_generator.sh $result.all.annotated blast
else
	echo -e "$(date)\tParsing $result"
	echo -e "$(date)\tThe filetype of $result is $filetype"
	echo -e "perl taxonomy_lookup.pl $result sam nucl $total_cores $tax_dir"
	#perl taxonomy_lookup.pl $result sam nucl $total_cores $tax_dir
	taxonomy_lookup.pl $result sam nucl $total_cores $tax_dir
	table_generator.sh $result.all.annotated sam
fi


