# Populates and indexes spatial geometry column geom in tables 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Populates and indexes spatial column "geom" in one or more tables. Processes by batches to avoid memory overload. Target table MUST be free of all indexes before processing, including primary key constraints. Adds temporary auto-increment primary key to select batches. This key is removed after use.

***Constraints and indexes on the spatial column remain after this operation is completed; run near end of pipeline, just prior to adding remaining indexes to table***. 

### II. Usage

```
$ ./populate_geom.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Use -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from UNIX "screen" session. Complete operation takes >= 12 hrs
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	