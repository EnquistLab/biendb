# One-time fixes to results of analytical db pipeline (not part of permanent pipeline)

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 10 Mar 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  
IV. Notes 

### I. Overview

* Create complete unindexed copy of view_full_occurrence_individual (vfoi), adding column taxonomic_status, and populating with contents of matched_taxonomic_status (redundant, for backwards compatibility, at Brian's request)
 * Creates complete unindexed copy of table analytical_stemp
 * Indexes PK of vfoi (taxonobservation_id)
 * Indexes FK from analytical_stem to view_full_occurrence_individual (taxonobservation_id)
 * Transfers contents of plot_metadata_id from vfoi to analytical_stem
 * Restores all remaining indexes on vfoi and analytical_stem
 
### II. Requirements

Requires the following tables in the production public database:
  * view_full_occurrence_individual
  * analytical_stem

### III. Usage

```
$ ./temp_fixes.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from UNIX "screen" session, as complete 
    operation takes ~ half hour to run
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
### IV. Notes

Run once only to update existing analytical db. These steps now added to complete pipeline.
