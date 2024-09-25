# Uploads new version of trait data to trait table in private  
# and public BIEN databases  

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 3 March 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  
IV. Schema  

### I. Overview

Creates new version of table agg_traits in development schema of private db. Uploads new trait file and populates agg_traits. Scrubs taxa with TNRS and updates taxon columns. Replaces original table agg_traits in core db with the new version from the development schema. Copies this table to the private analytical database and updates related summary tables taxon_trait and trait_summary.

Copies agg_traits to development schema of public database. Applies embargoes. Updates summary tables and transfers all tables to public schema. 

Run in five steps: 

(1) agg_traits_1.sh: Copy empty traits table to dev schema. Import new trait data to table. Export all unique taxa from parsing and scrubbing by TNRS. 
(2) [No script]. Manually upload taxon names to TNRS web application and parse; manually upload taxon names to TNRS web application and resolve. 
(3) agg_traits_3.sh: Import TNRS results and update traits table. 
(4) agg_traits_4.sh: Transfer table agg_traits to public schema in private db, replacing original version. Copy agg_traits to production private analytical database. Update tables taxon_trait and trait_summary.
(5) agg_traits_5.sh: Copy agg_traits to dev schema of public database. Apply embargoes. Update summary tables. Transfer table agg_traits to public schema in public db, replacing original version. Add datasource records to table datasource and populate FK datasource_id in table agg_traits. Update table taxon_trait.

### II. Requirements

Requires tables datasource in both public and private databases.

To execute step 2 (TNRS name resolution) upload the following file, which will be generated automatically in the data directory at the end of step 1:

taxon_verbatim.txt

The above file is uploaded twice to the TNRS website; once for parsing and once for full name resolution. The results of each of these operations must be saved to the data directory under the following names:

taxon_verbatim_parsed.txt
taxon_verbatim_scrubbed.txt

The above two files must be present in the data directory prior to running step 3.


### III. Usage

1. (Step 1) Place traits file in data folder. Make sure it is utf-8 with unix line endings.
2. Edit parameters as needed in params.inc
3. Run the following command (replacing 'X' with the appropriate number):

```
$ ./agg_traits_X.sh -m

```

4. After TNRS scrubbing is complete, place the TNRS parsing results and resolution results files in the data folder. Then run the remaining scripts.

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from UNIX "screen" session, as complete 
    operation takes ~ half hour to run
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
### IV. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
id | Integer primary key | 
traits_id | Old PK? Not used; column retained for back-compatibility | 
verbatim_family | Verbatim family | 
verbatim_scientific_name | Verbatim scientific name, including authority if present | 
name_submitted | Name as submitted to TNRS. Family-prepended if ends in '-aceae' | 
family_matched | Family matched by TNRS | 
name_matched | Taxon name matched by TNRS | 
name_matched_author | Correct author of the taxon matched by TNRS | 
higher_plant_group | [Not curerently populated, under construction] | 
tnrs_warning | Partial match' if name matched to a higher taxon than submitted; else NULL | 
matched_taxonomic_status | Taxonomic status of the matched name | 
scrubbed_taxonomic_status | Taxonomic status of the accepted name; if no accepted name then = matched_taxonomic_status | 
scrubbed_family | Final accepted family (or matched family if no accepted name found) | 
scrubbed_genus | Final accepted genus (or matched genus if no accepted name found) | 
scrubbed_specific_epithet | Specific epithet of final accepted taxon (or matched epithet if no accepted name found) | 
scrubbed_species_binomial | Final accepted species binomial (or matched species if no accepted name found) | 
scrubbed_taxon_name_no_author | Final accepted complete taxon (or matched taxon if no accepted name found) | 
scrubbed_taxon_canonical | Final accepted complete taxon, minus rank indicators if any (or matched canonical taxon if no accepted name found) | 
scrubbed_author | Authority of final accepted taxon (or authority of matched taxon if no accepted name found) | 
scrubbed_taxon_name_with_author | Final accepted complete taxon plus authority (or matched taxon if no accepted name found) | 
scrubbed_species_binomial_with_morphospecies | Final accepted species binomia l plus unmatched terms, if any (or matched morphospecies if no accepted name found) | 
trait_name | Trait name | 
trait_value | Trait value | 
unit | Trait value units | 
method | Description of method | 
region | Higher geographic unit | 
country | [if applicable] | 
stateprovince | [if applicable] | 
lower_political | [if applicable] | 
locality_description | [if applicable] | 
latitude | [if applicable] | 
longitude | [if applicable] | 
min_latitude | [if applicable] | 
max_latitude | [if applicable] | 
elevation | [if applicable] | 
source | Type of source ("published paper", etc.) | 
url_source | Source URL if applicable | 
source_citation | Plain text citation for this source | 
citation_bibtex | bibtext-formatted citation for this source | 
source_id | [not used] | 
visiting_date | ? | 
reference_number | [not used] | 
access | Level of access allowed to this source (not private records in public database) | private; public; public (notify the PIs)
project_pi | Lead contact for this source | 
project_pi_contact | Email of lead contact for this source | 
observation |  | 
authorship | Lead authors for this source | 
authorship_contact | Email of lead authors for this source | 
plant_trait_files | Source file for this record | 
fk_tnrs_user_id | FK to column user_id in TNRS results tables | 

