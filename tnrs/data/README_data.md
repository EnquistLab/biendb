# Input data for endangered species embargo pipeline

1. The following files must be present in the data directory prior to running endangered_species_1.sh:

cites.csv: verbatim csv export from cites website 
iucn.csv: verbatim csv export from iucn website 
usda.csv: verbatim csv export of threatened species from usda website 
metadata.csv: csv file of metadata for each of the above sources. 

Save all files as utf-8 with unix line endings.

### cites file

From: http://checklist.cites.org/#/en

### iucn file

From: http://www.iucnredlist.org/. 
Enter search term "Plantae" and press Download after results displayed.

### usda file

From: http://plants.usda.gov/threat.html
Use default settings. Press "Display Results". On results page, select tiny "download" hyperlink at upper right.

### metadata file

Header as follows:

source,date_accessed,version,url,citation

source: one of cites, iucn, or usda
date_accessed: download date
version: official version number if known
url: url where downloaded, if applicable, or project home page
citation: formatted literature citation for this source

2. The following file will be saved to this directory by endangered_species_1.sh:

taxon_verbatim.csv

Upload this file to the TNRS twice, once for full name resolution and a second time for parsing only. After these operations are complete, download the results to this directory as the following tab-delimitted utf-8 text files:

taxon_verbatim_parsed.txt
taxon_verbatim_scrubbed.txt

3. Run the remaining scripts, starting with endangered_species_2.sh.