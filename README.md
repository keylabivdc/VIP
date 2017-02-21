# Virus Identification Pipeline (VIP)

Quick Start Guide 

Virus Identification Pipeline (VIP) was developed for metagenomic identification of viral pathogen. VIP performs the following steps to achieve its goal: (i) map and filter out background-related reads, (ii) extensive classification of reads on the basis of nucleotide and remote amino acid homology, (iii) multiple k-mer based de novo assembly and phylogenetic analysis to provide evolutionary insight.

The results of VIP were displayed in HTML format. A demo result was available at http://yang.hukaa.com/1/

Please feel free to join the mailing list as well to ask any questions about VIP: https://groups.google.com/forum/#!forum/virus-identification-pipeline
# Introduction

VIP was developed by Department of Core Facility, National Institute for Viral Disease Control and Prevention (IVDC),  China Center for Disease Control and Prevention (China CDC)

Virus Identification Pipeline (VIP) is a one-touch computational pipeline for virus identification and discovery from metagenomic NGS data, rigorously tested across multiple clinical sample types representing a variety of infectious diseases. VIP has been tested on Ubuntu 14.04 and Biolinux 8. Other Linux distribution would be supported but not tested. Currently we are developing a user-friendly graphic interface (GUI).

# VIP-docker version

People worldwide paid attention to VIP used very different operating system, from MAC OS to various Linux system, such as Centos, Ubuntu, Redhat. It is a tough task to meet every system. Thanks to docker which can run at every system. So I chose docker as a container for VIP. If you are not familiar with docker, basically you can take it as a very light vitual machine. Please follow the steps to get the vip-docker.

First of all, please make sure docker is well installed in your system. You can also check the manual for useful tips.

	docker pull yang4li/vip-docker
	
	docker run -itd -v /etc/localtime:/etc/localtime:ro -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY yang4li/vip-docker /bin/bash
	
	#You will see a string which is the container ID.
	
	docker exec -it [Container ID] bash

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
		
		Please do not include any path information for the NGS file.
		
		For example, Good for VIP.sh -z -i test.fq 
					 Bad for VIP.sh -z -i [PATH]/test.fq 
		
	Run VIP with the config file:
		VIP.sh -c <configfile> -i <NGSfile>

	Run VIP with verification mode
		VIP.sh -i <NGSfile> -v

	(Note: The config file includes parameters for VIP to run. Each parameter can be modified based on your situation. Generally the default parameters are suitable for most cases.)
# Helps

Any questions can be sent to yang_li89@outlook.com

(Previous email address was eliminated. If I did not reply your emails, please send me with above address)

# Notes

We are working on the installation-scripts for CentOS. 
It should be noted that ETE module required X server for imaging. Not a good news for server...
In addition, we are also working on applying common workflow language (CWL).

# Paper

Li, Y. et al. VIP: an integrated pipeline for metagenomics of virus identification and discovery. Sci. Rep. 6, 23774; doi: 10.1038/srep23774 (2016).

# VIP developer notes
Version 0.2.0 19/Feb/2017 <br>
1, Add the mode switch. <br>
2, Accesion number could be well processed for taxonomy. <br>
3, VIP-docker was released. <br>

Version 0.1.1 26/Apr/2016 <br>
1, Fix errors of urls for downloading database. <br>
2, Fix an error while calculating the average depth. <br>
3, Add a script to parse the database. <br>
