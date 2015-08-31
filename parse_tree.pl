#!/usr/bin/perl -w
#
#	parse_tree.pl
#
#	This program will get the reference number and contig number.
#	Both number will be highlighted.
#	
#	parse_tree.pl <*.tree> <contig_num> <refgenome_num> <output>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved


if (@ARGV < 4) {
	die "usage: $0\t<*.tree> <contig_num> <refgenome_num> <output>\n";
}

open TREE, $ARGV[0] or die "Cannot open file:$!\n";

$contig = $ARGV[1];
$refgenome = $ARGV[2];
$output = $ARGV[3];
while (<TREE>) {
	chomp;
	$contig_num = $_ if /$contig/;
	$refgenome_num = $_ if /$refgenome/;
}
system "echo -e TreeView.py $ARGV[0] $contig_num $refgenome_num $output";
system "TreeView.py $ARGV[0] $contig_num $refgenome_num $output";
