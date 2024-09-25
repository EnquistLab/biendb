# Populates endangered species columns in tables vfoi, analytical_stem and bien_taxonomy, and hides locality information for any endangered species.

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 4 January 2017 

### Contents

I. Overview  
II. Dependencies  
III. Schema changes  
IV. Usage  

### I. Overview

Adds columns cites, iucn, usda_fed and usda_state to vfoi and analytical_stem. In each column, text is verbatim classification according to source.

cites: CITES classification for any appendix (I, II or III)
iucn: IUCN status
usda_fed: Any federally-listed taxon, from USDA Plants
usda_state: any state-listed taxon, from USDA Plants

Run in five steps: 

(1) endangered_species_1.sh: Import endangered taxa and classifications from CITES, IUCN and USDA Plants, then export all unique taxa from parsing and scrubbing by TNRS. 
(2) [No script]. Manually upload taxon names to TNRS web application and parse; manually upload taxon names to TNRS web application and resolve. 
(3) endangered_species_3.sh: Import TNRS results, merging with endangered species lists
(4) endangered_species_4.sh: Copy tables vfoi and analytical_stems from public to development schema, adding new columns and updating with endangered species information. Applies endangered species embargoes to analytical_stem and vfoi, removing locality information as applicable.
(5) endangered_species_5.sh: Copy revised tables  vfoi and analytical_stem back to public database.

### II. Dependencies

##### Tables

Tables view_full_occurrence_individual (vfoi), bien_taxonomy must be present in the main public database prior to executing these scripts.

##### External data

Prior to step 1, the following files must be present in the data directory:

cites.csv: verbatim csv export from cites website 
iucn.csv: verbatim csv export from iucn website 
usda.csv: verbatim csv export of threatened species from usda website 
metadata: csv file of metadata on each of the above sources. Header as follows:

source,date_accessed,version,url,citation

source: one of cites, iucn, or usda
date_accessed: download date
version: official version number if known
url: url where downloaded, if applicable, or project home page
citation: formatted literature citation for this source

For usda download, go to http://plants.usda.gov/threat.html, use default setting and press "Display Results". On results page, select tiny "download" hyperlink at upper right.

Other sources are self explanatory. Be sure to select CSV as download format.

To execute step 2 (TNRS name resolution) upload the following file, which will be generated automatically in the data directory at the end of step 1:

taxon_verbatim.txt

The above file is uploaded twice to the TNRS website; once for parsing and once for full name resolution. The results of each of these operations must be saved to the data directory under the following names:

taxon_verbatim_parsed.txt
taxon_verbatim_scrubbed.txt

The above two files must be present in the data directory prior to running step 3.

### III. Schema changes

#### view_full_occurrence_individual

The following five columns are added to table vfoi:

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
cites | CITES Appendix, if any | 
iucn | IUCN status (EN and CR only) | 
usda_federal | US federal T & E status | 
usda_state | All US state T & E listing, if any | 
is_embargoed_observation | is record embargoed? | 0=not embargoed, 1=embargoed | 

#### endangered_taxa

New table created by this operation.

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
endangered_taxa_id       | integer primary key | 
taxon_scrubbed_canonical | canonical taxon name without rank indicators    | 
taxon_rank               | taxonomic rank    | 
cites_status             | status according to CITES    | 
iucn_status              | status according to IUCN    | 
usda_status_fed          | Federal US status according to USDA Plants    | 
usda_status_state        | US State status(es) according to USDA Plants    | 

### IV. Usage

```
$ ./endangered_species_1.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


