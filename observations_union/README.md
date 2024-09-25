# Creates & populates geospatial table observations_union

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 24 Mar 2017 

### Contents


I. Overview
II. Requirements
III. Schema
IV.Usage  

### I. Overview

Script "observations_union.sh" creates & populates geospatial table observations_union in the development analytical schema of private database, as part of the full analytical database pipeline. 

Script "observations_union_standalone.sh" creates table observations_union in production versions of the private and public analytical database, and is  executed independently as a standalone operation. It first creates observations_union within the production analytical schema. Next, it copies observations_union over to a development schema within the public databases, applies embargoes, and moves the new table to the production public analytical schema. Finally, the script updates the database version number in both public and private database.

Script "observations_union_geombien.sh" is a standalone script which copies  table observations_union from the public analytical database to database geombien.

### II. Requirements

Script "observations_union.sh" requires a partially-complete development version of the private analytical schema, with tables "view_full_occurrence_individual" present but not indexed, and table "ranges" present and indexed.

Script "observations_union_standalone.sh" requires a completed and fully-indexed  production version of the private analytical schema, with tables "view_full_occurrence_individual" and "ranges" present.

Script "observations_union_geombien.sh" requires databases public_vegbien and geombien. The completed & fully indexed production analytical database must be present in schema public_vegbien.public, and tables "view_full_occurrence_individual" and "ranges" must be present.


### III. Schema



### IV. Usage

```
$ ./observations_union.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from "screen" session as complete operation may take several hours
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


