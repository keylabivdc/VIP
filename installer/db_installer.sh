#!/bin/bash
#
#	db_installer.sh
#
#	This program will download the data files necessary to construct VIP reference data.
#
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-08-05
### Copyright (C) 2015 Yang Li and Xuejun Ma - All Rights Reserved


if [ $# -lt 1 ]
then
	echo "Please type $0 -h for helps"
	exit 65
fi

while getopts "r:h" opt
do
	case "$opt" in
		h) HELP=1
		;;
		r) REF_PATH=${OPTARG}
		   HELP=0
		;;
		?)	echo "Option -$OPTARG requires an argument. Please type $0 -h for helps" >&2 
			exit 65
      		;;
	esac
done

if [ $HELP -eq 1 ]
then
	cat <<USAGE
	
$0

This program will download necessary reference database for use with VIP. 

Command Line Switches:

	-h	Show this help

	-r	Specify directory to create for downloaded data
		(optional. If unsupplied, will default to current path ./ )
		
		Databases will be located at：
		(be CAREFUL to change these parameters!)
		
			tax_DB="$REF_PATH/TAX"

			host_DB="$REF_PATH/HOST/host"

			(default host is human. The database was constructed from human genomic DNA (GRCh38/hg38), rRNA (RefSeq), 				RNA (RefSeq), mitochondrial RNA (RefSeq) and sequences unplaced or unlocalized.)

			fast_nucl_DB="$REF_PATH/FAST/vipdb_fast"

			sense_prot_DB="$REF_PATH/SENSE/PROT/vipdb_sense_prot"

			sense_nucl_DB="$REF_PATH/SENSE/NUCL/vipdb_sense_nucl"

			sense_bac_DB="$REF_PATH/BAC/vipdb_sense_bac"

Usage:

$0 -r [PATH]/[TO]/[VIPDB]

USAGE
	exit
fi

if [ ! -d $REF_PATH ]
then
	mkdir "$REF_PATH"
fi

download_file ()
{
	path_local=$1
	path_remote=$2
	file=$3
	md5=$4
	
	cd $path_local
	wget "$path_remote/$file"
	echo "$file dowloaded"
	if [[ $md5 ]]
	then
		cd $path_local 
		wget "$path_remote/$md5"
		md5sum -c --status "$md5"
		if [ $? -ne 0 ]
		then
			echo -e "md5check of $file: failed"
			exit
		else
			echo -e "md5check of $file: passed "
		fi
	fi
}

PATH=$PATH:/usr/VIP/:/usr/VIP/bin/:/usr/VIP/bin/edirect/:$(pwd) #load files under vip

###############################
#	TAXONOMY DB
###############################

taxdump="taxdump.tar.gz"
taxdump_md5="taxdump.tar.gz.md5"
gi_taxid_nucl="gi_taxid_nucl.dmp.gz"
gi_taxid_prot="gi_taxid_prot.dmp.gz"
NCBI_tax_dir="ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/"

if [ ! -d "$REF_PATH/TAX/" ]
then
	mkdir "$REF_PATH/TAX/"
fi 

if [ ! -f "$REF_PATH/TAX/$taxdump" ]
then
	echo -e "$(date)\t$0\tDownloading $taxdump"
	cd "$REF_PATH/TAX"
	download_file "$REF_PATH/TAX" "$NCBI_tax_dir" "$taxdump" "$taxdump_md5"
else
	echo -e "$(date)\t$0\t$taxdump already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

if [ ! -f "$REF_PATH/TAX/$gi_taxid_nucl" ]
then
	echo -e "$(date)\t$0\tDownloading $gi_taxid_nucl"
	cd "$REF_PATH/TAX"
	download_file "$REF_PATH/TAX" "$NCBI_tax_dir" "$gi_taxid_nucl"
else
	echo -e "$(date)\t$0\t$gi_taxid_nucl already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

if [ ! -f "$REF_PATH/TAX/$gi_taxid_prot" ]
then
	echo -e "$(date)\t$0\tDownloading $gi_taxid_prot"
	cd "$REF_PATH/TAX"
	download_file "$REF_PATH/TAX" "$NCBI_tax_dir" "$gi_taxid_prot"
else
	echo -e "$(date)\t$0\t$gi_taxid_prot already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

##building taxonomy SQLite databases
cd "$REF_PATH/TAX"
if [ -f "taxdump.tar.gz" ] && [ -f "gi_taxid_nucl.dmp.gz" ] && [ -f "gi_taxid_prot.dmp.gz" ]
then
	echo -e "$(date)\t$0\tTaxonomy files found."
	tar xfz $taxdump
	pigz -dc -k "$gi_taxid_nucl" > gi_taxid_nucl.dmp
	pigz -dc -k "$gi_taxid_prot" > gi_taxid_prot.dmp
	echo -e "$(date)\t$0\tStarting creation of taxonomy SQLite databases..."
	grep "scientific name" names.dmp > names_scientificname.dmp
	echo -e "$(date)\t$0\tStarting creation of taxonomy SQLite databases..."
	# cp create_taxonomy_db.py $REF_PATH
	# cd $REF_PATH
	create_taxonomy_db.py
	echo -e "$(date)\t$0\tCompleted creation of taxonomy SQLite databases."
	cd $REF_PATH
else
	echo -e "$(date)\t$scriptname\tNecessary files not found. Exiting..."
	exit
fi

###############################
#	HOST DB
###############################
HG38_DNA_DIR="ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/Assembled_chromosomes/seq/"
HG38_DNA="hs_ref_GRCh38.*.fa.gz"
HG38_RNA_DIR="ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/RNA/"
HG38_RNA="rna.fa.gz"

if [ ! -d "$REF_PATH/HOST/" ]
then
	mkdir "$REF_PATH/HOST/"
fi 

# for rRNA

if [ ! -f "$REF_PATH/HOST/human.rRNA.fa" ]
then
	echo -e "$(date)\t$0\tDownloading files for human.rRNA.fa"
	cd "$REF_PATH/HOST"
	efetch -format fasta -id 225637499,225637497,142372596,374429547,189571632 -db nuccore > human.rRNA.fa
else
	echo -e "$(date)\t$0\thuman.rRNA.fa already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

# for dna

if [ ! -f "$REF_PATH/HOST/$HG38_DNA" ]
then
	echo -e "$(date)\t$0\tDownloading files for human.dna.fa"
	cd "$REF_PATH/HOST"
	download_file "$REF_PATH/HOST" "$HG38_DNA_DIR" "$HG38_DNA"
else
	echo -e "$(date)\t$0\t$HG38_DNA already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi
cd "$REF_PATH/HOST"
sudo gzip -d -k $HG38_DNA
sudo sh -c 'cat hs_ref_GRCh38.*.fa > human.dna.fa'

# for rna

if [ ! -f "$REF_PATH/HOST/$HG38_RNA" ]
then
	echo -e "$(date)\t$0\tDownloading files for human.rna.fa"
	cd "$REF_PATH/HOST"
	download_file "$REF_PATH/HOST" "$HG38_RNA_DIR" "$HG38_RNA"
else
	echo -e "$(date)\t$0\t$HG38_RNA already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

cd "$REF_PATH/HOST"
gzip -dc -k "$HG38_RNA" > human.rna.fa

sudo sh -c 'cat human.rna.fa human.dna.fa human.rRNA.fa > vip_host.fa'

if [ ! -f "host.1.bt2" ]
then
	bowtie2-build vip_host.fa host
	echo -e "$(date)\t$0\tHuman database indexed. Next bacteria DB"
else
	echo -e "$(date)\t$0\tHuman database indexed. Next bacteria DB"
fi

###############################
#	BAC DB
###############################
BAC_DIR="ftp://ftp.lanl.gov/public/genome/gottcha/GOTTCHA_database_v20150825/"
BAC_DB="GOTTCHA_BACTERIA_c4937_k24_u30.species.tar.gz"

if [ ! -d "$REF_PATH/BAC/" ]
then
	mkdir "$REF_PATH/BAC/"
fi 

if [ ! -f "$REF_PATH/BAC/$BAC_DB" ]
then
	echo -e "$(date)\t$0\tDownloading files for "$BAC_DB""
	cd "$REF_PATH/BAC"
	download_file "$REF_PATH/BAC" "$BAC_DIR" "$BAC_DB"
else
	echo -e "$(date)\t$0\t$BAC_DB already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi
cd "$REF_PATH/BAC"
sudo sh -c 'gzip -dc -k "$BAC_DB" > vipdb_sense_bac.fa'

if [ ! -f vipdb_sense_bac.1.bt2 ]
then
	bowtie2-build vipdb_sense_bac.fa vipdb_sense_bac
	echo -e "$(date)\t$0\tBacteria database indexed. Next Virus DB for fast mode"
else
	echo -e "$(date)\t$0\tBacteria database indexed. Next Virus DB for fast mode"
fi

###############################
#	VIRUS DB FAST
###############################
VIR_NONFLU_DIR="http://www.viprbrc.org/brcDocs/datafiles/blast/DB_new_format/"
VIR_NONFLU="NONFLU_All.nt.tar.gz"
VIR_FLU_DIR="http://www.fludb.org/brcDocs/datafiles/blast/DB_new_format/"
VIR_FLU="Influenza_All.nt.tar.gz"

if [ ! -d "$REF_PATH/FAST/" ]
then
	mkdir "$REF_PATH/FAST/"
fi 

if [ ! -f "$REF_PATH/FAST/$VIR_NONFLU" ]
then
	echo -e "$(date)\t$0\tDownloading files for "$VIR_NONFLU""
	cd "$REF_PATH/FAST"
	download_file "$REF_PATH/FAST" "$VIR_NONFLU_DIR" "$VIR_NONFLU"
else
	echo -e "$(date)\t$0\t$VIR_NONFLU already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

if [ ! -f "$REF_PATH/FAST/$VIR_FLU" ]
then
	echo -e "$(date)\t$0\tDownloading files for "$VIR_FLU""
	cd "$REF_PATH/FAST"
	download_file "$REF_PATH/FAST" "$VIR_FLU_DIR" "$VIR_FLU"
else
	echo -e "$(date)\t$0\t$VIR_FLU already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

cd "$REF_PATH/FAST/"

if [ -f "$REF_PATH/FAST/$VIR_FLU" ] && [ -f "$REF_PATH/FAST/$VIR_NONFLU" ]
then
	echo -e "$(date)\t$0\tDatabase for VIP fast mode files found."
	tar zxf "$VIR_FLU"
	tar zxf "$VIR_NONFLU"
	cat Influenza_All.nt NONFLU_All.nt > vip_fast.fa
	echo -e "$(date)\t$0\tStarting getting a valid GI from the collections..."
	vip_db_format.pl vip_fast.fa
	echo -e "$(date)\t$0\tStarting creation of bowtie2-indexed databases..."
	bowtie2-build vip_fast.fa.formatted vipdb_fast
	echo -e "$(date)\t$0\tCompleted creation of Virus databases for FAST mode."
else
	echo -e "$(date)\t$0\tNecessary files not found. Exiting..."
	echo -e "$VIR_FLU\t$VIR_NONFLU"
	exit
fi

###############################
#	VIRUS DB SENSE 
###############################

if [ ! -d "$REF_PATH/SENSE/" ]
then
	mkdir "$REF_PATH/SENSE/"
fi 

###############################
#	AA DATABASE
###############################

VIP_SENSE_AA_DIR="ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/"
VIP_SENSE_AA="viral.1.protein.faa.gz"

if [ ! -d "$REF_PATH/SENSE/AA" ]
then
	mkdir "$REF_PATH/SENSE/AA"
fi

if [ ! -f "$REF_PATH/SENSE/AA/$VIP_SENSE_AA" ]
then
	echo -e "$(date)\t$0\tDownloading files for "$VIP_SENSE_AA""
	cd "$REF_PATH/SENSE/AA"
	download_file "$REF_PATH/SENSE/AA" "$VIP_SENSE_AA_DIR" "$VIP_SENSE_AA"
else
	echo -e "$(date)\t$0\t$VIP_SENSE_AA already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

cd "$REF_PATH/SENSE/AA"
#echo "sudo sh -c 'gzip -dc -k "$VIP_SENSE_AA" > vipdb_sense_AA.fa'"
#sudo sh -c 'gzip -dc -k "$VIP_SENSE_AA" > vipdb_sense_AA.fa'
gzip -dc -k "$VIP_SENSE_AA" > vipdb_sense_AA.fa

if [ ! -f vipdb_sense_prot]
then
	prerapsearch -d vipdb_sense_AA.fa -n vipdb_sense_prot
	echo -e "$(date)\t$0\tCompleted creation of Virus AMIO ACID databases for SENSE mode."
else
	echo -e "$(date)\t$0\tvipdb_sense_prot existed. Next for virus nucl databases for sense mode."
fi

###############################
#	NUCL DATABASE
###############################

VIP_SENSE_NUCL_DIR="ftp://ftp.ncbi.nlm.nih.gov/genomes/Viruses/"
VIP_SENSE_NUCL="all.fna.tar.gz"

if [ ! -d "$REF_PATH/SENSE/NUCL" ]
then
	mkdir "$REF_PATH/SENSE/NUCL"
fi

if [ ! -f "$REF_PATH/SENSE/NUCL/$VIP_SENSE_NUCL" ]
then
	echo -e "$(date)\t$0\tDownloading files for "$VIP_SENSE_NUCL""
	cd "$REF_PATH/SENSE/NUCL"
#	download_file "$REF_PATH/SENSE/NUCL" "$VIP_SENSE_NUCL_DIR" "$VIP_SENSE_NUCL"
	esearch -db nuccore -query "Viruses[Organism] NOT cellular organisms[ORGN] NOT wgs[PROP] NOT gbdiv syn[prop] AND (srcdb_refseq[PROP] OR nuccore genome samespecies[Filter])" | efetch -format fasta > all_virus.fna
else
	echo -e "$(date)\t$0\t$VIP_SENSE_NUCL already present. If you want to reinstall the file, please delete or backup the file and re-run the program."
fi

# cd "$REF_PATH/SENSE/NUCL"
# tar zxf "$VIP_SENSE_NUCL"
# cat */*.fna > all_virus.fna
sed "s/\(>gi|[0-9]*|\).*/\1/g" all_virus.fna > all_virus.fna.formatted


if [ ! -f "vipdb_sense_nucl.1.bt2" ] 
then
	bowtie2-build all_virus.fna.formatted vipdb_sense_nucl
	echo -e "$(date)\t$0\tCompleted creation of Virus NUCL databases for SENSE mode."
else
	echo -e "$(date)\t$0\tvipdb_sense_nucl existed. all database has been created."
fi

###############################
#	VIP tt
###############################

cd $REF_PATH
wget https://github.com/keylabivdc/VIP/blob/master/vip.tt
