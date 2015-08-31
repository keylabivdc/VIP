#!/usr/bin/perl -w
#
#	distributionCalc.pl
#
#	This program will get the total number of unclassfied reads.
#	
#	distributionCalc.pl <distribution file> <NGS file> <reads or virus>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
use strict;

if (@ARGV < 3) {
	die "usage: $0\t<distribution file> <NGS file> <reads or virus>\n";
}

open FL, "$ARGV[0]";
my $NGS = $ARGV[1];
my $reads = $ARGV[2];

my $others;
my $n = 1;

while (<FL>) {
	chomp;
	my @temp = split /\t/;
	if ($n == 1) {
		$others = $temp[1];
	} else {
		$others = $others - $temp[1];
	#	print "$others\n";
	}
	$n++;
	#print "temp1:$temp[1]\n";	
}

if ($reads =~ /reads/) {
	system(`echo "Others\t$others" >> $NGS.reads_distribution`);
} #else {
#	`echo -e "Others\t$others" >> temp.top5virus.$NGS`;
#}
