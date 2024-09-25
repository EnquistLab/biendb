# Copies political division lookup tables from GNRS database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents


I. Overview  
II. Requirements  
III. Schema  
IV.Usage  
V. Warnings    

### I. Overview

Script "poldiv_tables.sh" copies geonames lookup table countries from database geoscrub to analytical database. Also creates tables state_province and county_parish in db geonames and copies to analytical db.

### II. Requirements

Requires tables countries & geonames in database geoscrub.

### III. Schema



### IV. Usage

```
$ ./poldiv_tables.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

### V. Warnings

Currently only copies tables to public database. Not yet implemented for private database.
