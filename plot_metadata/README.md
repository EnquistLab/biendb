# Creates BIEN analytical table plot_metadata

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 11 Oct 2016

### Contents

I. Overview  
II. Requirements  
III. Schema  
IV. SQL  
V. Usage  
VI. Caveats  

### I. Overview

Creates analytical table plot_metadata with one record for each 
plot in table view_full_occurrence_individual (vfoi). Adds information 
on data providers, data ownership and several columns pertaining to   
methodology. Also modifies table vfoi, adding integer foreign key to
table plot_metadata.

Table is created by selecting all distinct values of datasource, 
plot_name, dataset, dataowner, plot_methodology and plot_area_ha 
from vfoi. Additional methodology columns are added and missing 
values populated from a manually-prepared spreadsheet (saved 
as CSV file) uploaded from the data directory for this application. 

### II. Requirements

The following tables must be present in development schema:

view_full_occurrence_individual_dev
analytical_stem

Note that column dataset should already be populated in vfoi_dev, and copied over to analytical_stem

The following data files (here variable names) must be present in local data directory. Actual file names are set in local params file.

meta_file_cvs		Metadata for source CSV
meta_file_vegbank	Metadata for source vegbank
meta_file_bien2		Metadata for source BIEN2
meta_file_general	Metadata for misc sources

### III. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
plot_metadata_id | Integer primary key | 
datasource | Short code for the primary data provider to BIEN | 
dataset | Short code for a group of plots within a datasource which are administered by a single data owner | 
plot_name | The original (author) plot code; unique within datasource + dataset only | 
datasource_plot_id | Plot code assigned by datasource. Unique within datasource. May or may not be same as plot_name | 
dataowner | Name of the owner of the data. If more than one owner, this person is the primary contact | 
primary_dataowner_email | Email of dataowner | 
plot_area_ha | Area of the plot in ha | 
sampling_protocol | A unique code or phrase for describing standard sampling methodology | 
abundance_measurement | Does plot count individual stems or species cover? | "Individuals", "Cover"
abundance_measurement_description | Optional unconstrained description of details of the abundance measurement | 
has_strata | Are observations grouped within height strata? | "Yes", "No"
has_stem_data | Does plot contain individual stem measurements? | "Yes", "No"
methodology_reference | Link or citation describing the methodology | 
methodology_description | Optional unconstrained description of details of the sampling methodology | 
stem_diam_min | Minimum stem diameter included | 
stem_diam_min_units | Units for minimum stem diameter | 
stem_diam_max | Maxiumu stem diameter included | 
stem_diam_max_units | Units for maximum stem diameter | 
stem_measurement_height | Minimum stem height included | 
stem_measurement_height_units | Units for minimum stem height | 
growth_forms_included_all | Are all growth forms potentially included without specific exclusions? | "Yes", "No"
growth_forms_included_trees | Are trees included? | "Yes", "No"
growth_forms_included_shrubs | Are shrubs included? | "Yes", "No"
growth_forms_included_lianas | Are lianas included? | "Yes", "No"
growth_forms_included_herbs | Are herbs included? | "Yes", "No"
growth_forms_included_epiphytes | Are epiphytes included? | "Yes", "No"
growth_forms_included_notes | Notes on growth form inclusions or exclusions | 
taxa_included_all | Are all taxonomic groups (embryophytes only) potentially included? | "Yes", "No"
taxa_included_seed_plants | Are all seed plants potentially included? | "Yes", "No"
taxa_included_ferns_lycophytes | Are all ferns and lycophytes potentially included? | "Yes", "No"
taxa_included_bryophytes | Are all mosses, liverworts, hornworts potentially included? | "Yes", "No"
taxa_included_exclusions | Notes on any taxonomic exclusions or inclusons | 

### IV. SQL

Join to view_full_occurrence_individual:

```
SELECT ...
FROM plot_metadata a JOIN view_full_occurrence_individual b
ON a.plot_metadata_id=b.plot_metadata_id 

```

### V. Usage

```
$ .plot_metadata.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * WARNING: Run from unix "screen" session; complete operation may take 
  	several days.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

### VI. Caveats

  * Table plot_metadata is populated by extracting information from 
  	analytical database. This is a hack. Eventually this script should be
  	replaced by one that build plot_metadata directly from information in  
  	the normalized core database
  * Table plot_metadata is currently built only within the public database.  
  	Eventual solution should be built within the private (main) analytical
  	database, and copied over to the public database after applying  
  	embargoes.
