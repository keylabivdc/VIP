#!/usr/bin/perl -w
#
#	vip_db_format.pl
#
#	This script will keep the necessary GI and sequences. It has been tested with Ubuntu 14.04 LTS.
#
#	quick guide:
#
#	./vip_db_format.pl <fasta_file>
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
### Copyright (C) 2014 Yang Li - All Rights Reserved
use strict;

if (@ARGV < 1) {
	die "usage: <sequence file>\n";
	exit;
}

open FL, "$ARGV[0]" or die "Cannot open file: $!\n";
open OUTPUT, ">$ARGV[0].formatted";
open NOGI, ">$ARGV[0].NO_VALID_GI";


$/=">";

while (<FL>) {
	chomp;
	if (/.*(gi\|[0-9]*\|).*?\n(.*)/si) {
	#if (/.*?(gi\|[0-9]*\|).*?\n(.*)/si) {
		my $gi = lc($1);
		my $seq = $2;
		print OUTPUT ">$gi\n";
		print OUTPUT "$2";
	} else {
		print NOGI ">$_";
	}
}

close FL;
close OUTPUT;
