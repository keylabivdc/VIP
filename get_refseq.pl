#!/usr/bin/perl -w
#
#	get_refseq.pl
#
#	This program will dowload the sequences with Refseq standard under a genus.
#	
#	get_refseq.pl <GENUS>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
use strict;

if (@ARGV != 1) {
    die "Usage:$0 <GENUS>\n";
}

#open GENUS, "$ARGV[0]" or die $!;
my $genus = $ARGV[0];

my $taxid = `esearch -db taxonomy -query "$genus" | efetch -format taxid`;

#print "$taxid\n";
`esearch -db nuccore -query "refseq[filter] AND txid$taxid\[Organism]" | efetch -format fasta > temp.refseq.$genus.fasta`
