# Creates BIEN analytical tables dataset, party and related tables

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Dependencies  
III. Usage  
IV. Schema  
V. SQL  
VI. Caveats  

### I. Overview

Creates analytical table dataset with one record for each distinct dataset (group of related plots, specimens or other observations) in the BIEN database. For each Populates it with existing data source information, as extracted from (1) analytical table plot_metadata (plot data only), (2) view_full_occurrence_individual (vfoi; specimen data only), and (3) Index Herbariorum (local copy; specimen data only). Foreign keys are added to tables plot_metadata, vfoi and analytical_stem. 

During this process, a CSV file of the contents of the completed table dataset (dataset.csv) is exported, to be used to enter missing content manually. This information can then be reimported and table dataset rebuilt by executing script update_dataset.sh. See separate module update_dataset for instructions on update table dataset from this file.

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
$ ./create_dataset.sh -m

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

* dataset
| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
dataset_id	|	Integer primary key	|	
dataset_name	|	Short name for this dataset 
dataset_fullname	|	Optional longer name for this dataset 
citation	|	Literature citation for this dataset (bibtex format)	|	
access_conditions	|	default conditions of use for this dataset	|	'acknowledge', 'offer coauthorship', 'contact authors'
access_level	|	Default level of access to this dataset	|	'hidden', 'private', 'public'
locality_error_added	|	Are locality details hidden or fuzzed for this dataset?	|	'f', 't'
locality_error_details	|	Details of hiding/fuzzing rules, if any	|	

* party
| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
party_id	|	Integer primary key	|	
partyname	|	Full name or insitution_code |	
institution_shortname	|	Unique short code for this institution (if applicable)	|		
institution_fullname	|	Populated if this is an institution	|		
firstname	|	First name if person	|	
lastname	|	Last name if person	|	
fullname	|	full name of person	|	
email	|	Primary contact person for this dataset	|	
url	|	Main URL providing information on this dataset	|	
citation	|	Literature citation for this dataset (bibtex format)	|	

* dataset_party
| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
dataset_party_id	|	Integer primary key	|	
dataset_id	|	Integer primary key	|	
party_id	|	Integer primary key	|	
party_role	|	Relationship of party to the dataset |	
is_primary	|	Use this records are primary contact or owner for dataset	| 0,1	
access_conditions	|	Conditions of use for this dataset, if applicable	|	'acknowledge', 'offer coauthorship', 'contact authors'


### V. SQL

Join to view_full_occurrence_individual:  

```
SELECT ...
FROM dataset a JOIN view_full_occurrence_individual b
ON a.dataset_id=b.dataset_id

```

Join to plot_metadata:

```
SELECT ...
FROM dataset a JOIN plot_metadata b
ON a.dataset_id=b.dataset_id

```

Join to analytical_stem:

```
SELECT ...
FROM dataset a JOIN analytical_stem b
ON a.dataset_id=b.dataset_id

```

### VI. Caveats

  * Table dataset is populated by extracting information from analytical database. Eventually this script should be replaced by one that builds dataset directly from information in  the normalized core database.
  * Ideally, dataset information in plot_metadata should be extracted from dataset and not vice-versa as done here.



