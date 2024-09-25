# Remove records from database for one or more sources

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

1. remove_duplicate_sources.sh

Removes data and metadata from legacy tables of sources that will be imported or updated later in pipeline. Deletes records from the following tables:

2. remove_secondary_sources.sh

Removes records of any BIEN primary data provider which are not provided directly by that provider. For example, any MO records not provided by MO are removed from GBIF, etc. All such sources should be acronyms of herbaria that provide data directly to bien. Required parameter $primary_sources set in global params file.

Both scripts delete records related to one or more source from the following tables:

* view_full_occurrence_individual_dev
* analytical_stem_dev 
* datasource (if plot data)
* plot_metadata (if plot data)

Database and schema are not derived from global params file and MUST be supplied by command line parameters. See below under Usage.

### II. Usage

Sourced by main DB pipeline, but can be run standalone as follows.

```
./remove_duplicate_sources.sh -d db_name -c schema_name

```

* Options:  
  -d: database  
  -c: schema 


```
./remove_secondary_sources.sh -d db_name -c schema_name

```

* Options:  
  -d: database  
  -c: schema 
