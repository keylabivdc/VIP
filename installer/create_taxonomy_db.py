#!/usr/bin/python
#
#	create_taxonomy_db.py
#
#	modified from https://github.com/chiulab/surpi
#
#	Quick guide:
#	
#		Create SQL database for query gi to scientific name.
#		1, gi to taxid; 
#		2, taxid to taxonomy lineage.
#		
### Authors : Yang Li <liyang@ivdc.chinacdc.cn>
### License : GPL 3 <http://www.gnu.org/licenses/gpl.html>
### Update  : 2015-07-05

import sqlite3

# Create names_nodes_scientific.db
print ("Creating names_nodes_scientific.db...")
conn = sqlite3.connect('names_nodes_scientific.db')
c = conn.cursor()
c.execute('''CREATE TABLE names (
			taxid INTEGER PRIMARY KEY,
			name TEXT)''')

with open('names_scientificname.dmp', 'r') as map_file:
	for line in map_file:
		line = line.split("|")
		taxid = line[0].strip()
		name = line[1].strip()
		
		c.execute ("INSERT INTO names VALUES (?,?)", (taxid, name))

d = conn.cursor()
d.execute('''CREATE TABLE nodes (
			taxid INTEGER PRIMARY KEY,
			parent_taxid INTEGER, 
			rank TEXT)''')

with open('nodes.dmp', 'r') as map_file:
	for line in map_file:
		line = line.split("|")
		taxid = line[0].strip()
		parent_taxid = line[1].strip()
		rank = line[2].strip()
		
		d.execute ("INSERT INTO nodes VALUES (?,?,?)", (taxid, parent_taxid, rank))
conn.commit()
conn.close()

# Create gi_taxid_nucl.db
print ("Creating gi_taxid_nucl.db...")
conn = sqlite3.connect('gi_taxid_nucl.db')
c = conn.cursor()
c.execute('''CREATE TABLE gi_taxid (
			gi INTEGER PRIMARY KEY,
			taxid INTEGER)''')

with open('gi_taxid_nucl.dmp', 'r') as map_file:
	for line in map_file:
		line = line.split()
		c.execute("INSERT INTO gi_taxid VALUES ("+line[0]+","+line[1]+")")
conn.commit()
conn.close()

# Create gi_taxid_prot.db
print ("Creating gi_taxid_prot.db...")
conn = sqlite3.connect('gi_taxid_prot.db')
c = conn.cursor()
c.execute('''CREATE TABLE gi_taxid (
			gi INTEGER PRIMARY KEY, 
			taxid INTEGER)''')

with open('gi_taxid_prot.dmp', 'r') as map_file:
	for line in map_file:
		line = line.split()
		c.execute("INSERT INTO gi_taxid VALUES ("+line[0]+","+line[1]+")")

conn.commit()
conn.close()
