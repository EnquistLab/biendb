# Creates BIEN analytical table datasource

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 18 Nov 2016

### Contents

I. Overview  
II. Dependencies  
III. Usage  
IV. Schema  
V. SQL  
VI. Caveats  

### I. Overview

Creates analytical table datasource with one record for each distinct proximate data_provider ("datasource") plus dataset combination in the BIEN database. Populates it with existing data source information, as extracted from (1) analytical table plot_metadata (plot data only), (2) view_full_occurrence_individual (vfoi; specimen data only), and (3) Index Herbariorum (local copy; specimen data only). Foreign keys added to tables plot_metadata, vfoi and analytical_stem. 

During this process, a CSV file of the contents of the completed table datasource (datasource.csv) is exported, to be used to enter missing content manually. This information can then be reimported and table datasource rebuilt by executing script update_datasource.sh. See separate module update_datasource for instructions on update table datasource from this file.

### II. Dependencies

The following tables must be present in development schema:

view_full_occurrence_individual_dev
analytical_stem_dev
plot_metadata

The following table:

ih 

must be present in schema "herbaria" of database "vegbien". 
  	
### III. Usage

```
$ ./create_datasource.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from "screen" session, as complete 
    operation takes a while
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
### IV. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
datasource_id	|	Integer primary key	|	
proximate_provider_datasource_id	|	Recursive foreign key to the source that provided the data to BIEN	|	
proximate_provider_name	|	Unique short text code for the source that provided the data to BIEN	|	
source_name	|	Short text code for this dataset, unique within a given proximate provider	|	
source_fullname	|	Full name of dataset	|	
source_type	|	Relationship between source and dataset	|	'data owner', 'proximate provider', 'data owner & proximate provider'
observation_type	|	Type of observations in dataset	|	'plot', 'specimen'
is_herbarium	|	TRUE (1) if source is a herbarium with official acronym	|	'0', '1'
primary_contact_institution_name	|	Primary insititutional contact for this dataset	|	
primary_contact_firstname	|	Primary contact person for this dataset	|	
primary_contact_lastname	|	Primary contact person for this dataset	|	
primary_contact_fullname	|	Primary contact person for this dataset	|	
primary_contact_email	|	Primary contact person for this dataset	|	
source_url	|	Main URL providing information on this dataset	|	
source_citation	|	Literature citation for this dataset (bibtex format)	|	
access_conditions	|	Conditions of use for this dataset	|	'acknowledge', 'offer coauthorship', 'contact authors'
access_level	|	Level of access to this dataset	|	'hidden', 'private', 'public'
locality_error_added	|	Are locality details hidden or fuzzed for this dataset?	|	'f', 't'
locality_error_details	|	Details of hiding/fuzzing rules, if any	|	

### V. SQL

Join to view_full_occurrence_individual:  

```
SELECT ...
FROM datasource a JOIN view_full_occurrence_individual b
ON a.datasource_id=b.datasource_id

```

Join to plot_metadata:

```
SELECT ...
FROM datasource a JOIN plot_metadata b
ON a.datasource_id=b.datasource_id

```

Join to analytical_stem:

```
SELECT ...
FROM datasource a JOIN analytical_stem b
ON a.datasource_id=b.datasource_id

```

### VI. Caveats

  * Table datasource is populated by extracting information from analytical database. Eventually this script should be replaced by one that builds datasource directly from information in  the normalized core database.
  * Ideally, data source information in plot_metadata should be extracted from datasource and not vice-versa as done here.



