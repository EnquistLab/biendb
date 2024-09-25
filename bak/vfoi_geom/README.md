# Populates and indexes spatial column geom in table 
# view_full_occurrence_individual

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 5 April 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Populates and indexes spatial column "geom" in table "view_full_occurrence_individual_dev" in development schema. Processes one species at a time to avoid memory overload.

### II. Requirements

Requires the following table in the development schema of private database:
  * view_full_occurrence_individual

### III. Usage

```
$ ./vfoi_geom.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Use -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from UNIX "screen" session. Complete operation takes >= 12 hrs
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	