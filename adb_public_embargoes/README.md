# Applies embargoes to public analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 10 March 2017

### Contents

I. Overview  
II. Main steps
III. Requirements  
IV. Usage  

### I. Overview

Applies dataset and taxon embargoes to public analytical database, and rebuilds metadata tables as needed. Dataset embargoes delete all records pertaining to a particular dataset. Taxon embargoes hide locality information for all endangered taxa, as listed in table endangered_taxa and as indicated by column is_embargoed_observation in table view_full_occurrence_individual.

### I. Main steps

1. Taxon embargoes
* NULLs latitude & longitude and substitutes embargo message for endangered species observations
* Uses "CREATE TABLE xxx AS " approach to speed up operation and avoid memory overload. This also strips indexes, which speeds up dataset embargoes.

2. Dataset embargoes:

**remove_madidi.sql**
* Removes all observations and plot data for dataset SALVIAS: Madidi
* Keeps metadata in tables datasource and plot_metadata

**remove_remib.sql**
* Removes all observations for specimen dataset REMIB

**remove_nonpublic_traits.sql**
* Removes all non-public traits records from table agg_traits

**remove_nvs.sql**
* Removes all observations and plot data for datasource NVS
* Keeps metadata in tables datasource and plot_metadata

3. Rebuild metadata tables
* Rebuilds tables that store counts of observations & taxa

4. Rebuild indexes
* Rebuilds indexes on any tables copied during step 1.

### III. Requirements

Complete private schema analytical_db_dev must already exist.
 

### IV. Usage

```
$ ./adb_public_embargoes.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  * Recommend run in unix screen, with -m option, as operation takes many hours.
  	
