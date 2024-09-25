# Adds data provenance columns to view_full_occurrence_individual

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Overview

Populates columns dataset (=primary project), dataowner (=primary data owner),   
primarydataowneremail in anaytical table view_full_occurrence_individual (vfoi).     

Much of this information was not included in the core BIEN database and  
therefore must be retrieved from the original raw data imports. Each import resides in its own schema in database vegbien. The name of the schema is the
name of the datasource.

In future, should add this information to table vfoi as it is generated in the   core database. 

### Usage

```
$ ./data_provenance.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
