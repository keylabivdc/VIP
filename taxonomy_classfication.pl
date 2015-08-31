#!/usr/bin/perl -w
#
#
#	taxonomy_classfication.pl
#
#	Quick guide:
#	It will parse the annotated sam/blast file and calculate the total number classfied by species/genus/family
#
#		taxonomy_classfication.pl <file>
#
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05
#

use strict;


#
#usage: *.pl <file>
#

open FL, $ARGV[0] or die "Cannot open file: $!\n";
#our $filename = shift @ARGV;
#our ($gi, $species, $genus, $family) = @ARGV;

our (%gi_count, %species_count, %genus_count, %family_count, %unknown_count);
our (@temp, $temp_link);
#output
open OUT_gi, ">$ARGV[0].gi.counttable";
open OUT_species, ">$ARGV[0].species.counttable";
open OUT_genus, ">$ARGV[0].genus.counttable";
open OUT_family, ">$ARGV[0].family.counttable";
open OUT_unknown, ">$ARGV[0].unknown.counttable";

while (<FL>) {
    chomp;
    @temp = split /\t/;
    unless ( defined $temp[2] ) {
	$temp[2] = "unknown";
	$unknown_count{$temp[2]} += 1;
	next;
    }
    $temp_link = "$temp[1]\t$temp[2]";
    $gi_count{$temp_link} += 1;
    $species_count{$temp[2]} += 1;
    unless ( defined $temp[3] ) {
        $temp[3] = "unknown";
    }
    $genus_count{$temp[3]} += 1;
    unless ( defined $temp[4] ) {
        $temp[4] = "unknown";
    }
    $family_count{$temp[4]} += 1;
}

my ($key, $value);

while (($key, $value) = each %gi_count) {
	print OUT_gi "$key\t$value\n";
}

while (($key, $value) = each %species_count) {
	print OUT_species "$key\t$value\n";
}

while (($key, $value) = each %genus_count) {
	print OUT_genus "$key\t$value\n";
}

while (($key, $value) = each %family_count) {
	print OUT_family "$key\t$value\n";
}

while (($key, $value) = each %unknown_count) {
	print OUT_unknown "$key\t$value\n";
}

close FL;
close OUT_gi;
close OUT_species;
close OUT_genus;
close OUT_family;
close OUT_unknown;



