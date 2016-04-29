# Virus Identification Pipeline (VIP)

Quick Start Guide 

Virus Identification Pipeline (VIP) was developed for metagenomic identification of viral pathogen. VIP performs the following steps to achieve its goal: (i) map and filter out background-related reads, (ii) extensive classification of reads on the basis of nucleotide and remote amino acid homology, (iii) multiple k-mer based de novo assembly and phylogenetic analysis to provide evolutionary insight.

The results of VIP were displayed in HTML format. A demo result was available at http://yang.hukaa.com/1/

Please feel free to join the mailing list as well to ask any questions about VIP: https://groups.google.com/forum/#!forum/virus-identification-pipeline
# Introduction

VIP was developed by Department of Core Facility, National Institute for Viral Disease Control and Prevention (IVDC),  China Center for Disease Control and Prevention (China CDC)

Virus Identification Pipeline (VIP) is a one-touch computational pipeline for virus identification and discovery from metagenomic NGS data, rigorously tested across multiple clinical sample types representing a variety of infectious diseases. VIP has been tested on Ubuntu 14.04 and Biolinux 8. Other Linux distribution would be supported but not tested. Currently we are developing a user-friendly graphic interface (GUI).

# Installation

The steps to install VIP on a machine are as follows:

	> git clone https://github.com/keylabivdc/VIP
	
	> cd VIP
	
	> cd installer
	
	> chmod 755 *
	
	> sudo sh dependency_installer.sh
	
	> sudo sh db_installer.sh -r [PATH]/[TO]/[DATABASE]
	

# Usage

	Create default config file.
		VIP.sh -z -i <NGSfile> -p <454/iontor/illumina> -f <fastq/fasta/bam/sam> -r <reference_path>

	Run VIP with the config file:
		VIP.sh -c <configfile> -i <NGSfile>

	Run VIP with verification mode
		VIP.sh -i <NGSfile> -v

	(Note: The config file includes parameters for VIP to run. Each parameter can be modified based on your situation. Generally the default parameters are suitable for most cases.)
# Helps

Any questions can be sent to liyang@ivdc.chinacdc.cn

# Notes

We are working on the installation-scripts for CentOS. 
It should be noted that ETE module required X server for imaging. Not a good news for server...
In addition, we are also working on applying common workflow language (CWL).

# VIP developer notes

Version 0.1.1 26/Apr/2016 <br>
1, Fix errors of urls for downloading database. <br>
2, Fix an error while calculating the average depth. <br>
3, Add a script to parse the database. <br>
