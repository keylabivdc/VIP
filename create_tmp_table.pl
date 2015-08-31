#!/usr/bin/perl
#
#	create_tmp_table.pl
#
#	This program will generate a file which include the id, gi, species, genus, family information in a tabular text.
#
#	create_tmp_table.pl <annotated BOWTIE file> <annotated RAPSearch file> <NGS> <mode> <platform>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
use Getopt::Std;
use strict;

our ($opt_f, $opt_h);
open OUT, ">$ARGV[2].tempsorted";
getopts('f:h');

if ($opt_h) {
	print <<USAGE;
	
create_tab_delimited_table.pl

This program will generate a file which include the id, gi, species, genus, family information in a tabular text as:

	header	gi	species	genus	family
	

Usage:

create_tab_delimited_table.pl -f sam <file>

create_tab_delimited_table.pl -f blast <file>

USAGE
	exit;
}
while (<>) {
	my ($species, $genus, $family) = ("") x 3;
	my @columns = split/\t/, $_;
	if (/species--(.*?)\t/) {
		$species = $1;
	}
	if (/genus--(.*?)\t/) {
		$genus = $1;
		}
	if (/family--(.*?)\t/) {
		$family = $1;
	}
	if ($opt_f eq "sam") {
		print OUT "$columns[0]\t$columns[2]\t";
	}
	else {
		$columns[1] =~ /(gi\|\d+\|)/;
		print OUT "$columns[0]\t$1\t";
	}
	print OUT "$species\t$genus\t$family\n";
}
