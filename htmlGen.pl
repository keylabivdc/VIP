#!/usr/bin/perl -w
#
#	htmlGen.pl
#
#	This program will collect all the information for final view in html.
#	
#	htmlGen.pl <.table> <NGS> <mode> <total_time> <vip_dir>
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved
use strict;
use warnings;

use Template;

if ( @ARGV < 5 ) {
	die "usage: $0 <.table> <NGS> <mode> <total_time> <vip_dir>";
} 

open my $fh, "$ARGV[0]";
my $header = <$fh>;
chomp $header;
my @h = split /\t/, $header;
my @lines;
my %pics_phygo;
my %pics_covplot;
while (my $line = <$fh>) {
    chomp $line;
    my @f = split /\t/, $line;
    my @phygo = glob("phygo.$f[1].*.png");
    my @covplot = glob("covplot.$f[1].*.png");
#    if (@files) {
#        print $files[0], "\n";
#        $pics{$f[1]} = $files[0];
#    }
    if (@phygo && @covplot){
        print $phygo[0], " Loaded\n";
        print $covplot[0], " Loaded\n";
        $pics_phygo{$f[1]} = $phygo[0];
        $pics_covplot{$f[1]} = $covplot[0];
    }
    
    push @lines, \@f;
}
my $report_name = "$ARGV[1]";
my $cur_time = `date`;
my $vip_dir = "$ARGV[4]";
my $t = Template->new({INCLUDE_PATH => "$vip_dir"});
my $mode = "$ARGV[2]";
my $total_time = "$ARGV[3]";
$t->process("vip.tt", { 
	h => \@h, 
	lines => \@lines, 
	pics_phygo => \%pics_phygo, 
	pics_covplot => \%pics_covplot, 
	report_name => $report_name, 
	cur_time => $cur_time, 
	mode => $mode,
	total_time => $total_time}, "VIP_report.html") || die $t->error();

