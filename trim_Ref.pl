#!/usr/bin/env perl
#
#	trim_Ref.pl
#
#	This program will get gi and scientific name of each record for further displaying in the phylogenetic tree.
#	
#	trim_Ref.pl <refseq>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
if (@ARGV != 1) {
    die "Usage:$0 <refseq>\n";
}

open(FL, "$ARGV[0]") or die "Cannot find file:$!\n";
open(OUT, ">$ARGV[0].formatname");
$/ = ">";
while (<FL>) {
	chomp;
	if (/.*?\|.*?\|.*?\|(.*?)\..*?\|.*?\s(.*?)\n(.*)/ms) {
		$gi = $1;
		$refname = $2;
		$refseq = $3;
		$refname =~ s/\s/_/g;
		$refname =~ s/\,.*//g;
		print OUT ">$gi\_$refname\n$refseq\n";
	}
}
