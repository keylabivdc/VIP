#!/usr/bin/perl -w
#
#	get_complete.pl
#
#	Quick guide:
#	This program will choose the reference sequences with the following key words are kept: (1) complete genomes; (2) complete sequences; or (3) complete cds.
#
#		get_complete.pl <reference_sets fasta>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
use strict;

if (@ARGV != 1) {
	die "Usage: $0 <FASTA FILE>\n";
}
open FASTA, "$ARGV[0]" or die "Can not open file:$!\n";
open OUT, ">$ARGV[0].blastdb.fasta";

$/ = ">";
my $top;
my $flag = 0;
my $n = 0;

while (<FASTA>) {
	chomp;
	if ($n == 1) {
		$top = $_
	}
	if ($flag == 1) {
		last;	
	}
	if (/complete sequence/gi) {
		print OUT ">$_";
		$flag = 1;
	} elsif (/complete genome/gi) {
		print OUT ">$_";
		$flag = 1;
	} elsif (/complete cds/gi) {
		print OUT ">$_";
		$flag = 1;	
	}
	$n++
}

if ($flag == 0) {
	print OUT ">$top";
}
