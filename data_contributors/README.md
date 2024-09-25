# Creates table data_contributors in BIEN analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 5 March 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  
IV. Schema  

### I. Overview

Creates table data_contributors, containing metadata on all BIEN data contributors, plus a count of observations from that contributors. Similar to table datasource but formatted for display on the BIEN website.

### II. Requirements

Requires the following tables in the development schema:
  * view_full_occurrence_individual_dev
  * datasource
  * ih [index_herbariorum]

### III. Usage

```
$ ./data_contributors.sh

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * -m switch generates start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
### IV. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
 datasource_id | Primary key, inherited from table datasource  |  
 provider    | data contributor short name | 
 sourcetype    | type of database | 'aggregator','herbarium','primary database'
 observationtype    | type of observations | 'plot','specimen'
 obs    | total observations for this source | 
 url    | home page url for this source, if available | 
 is_herbarium    | is source in Index Herbariorum? | 1 (yes), 0 (no)
 url_ih    | Index Herbariorum url, if applicable | 
 provider_name    | Long name for this source | 
 city    | [if applicable] | 
 state_province    | [if applicable] | 
 country    | [if applicable] | 

