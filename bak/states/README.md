# Copies political division lookup tables from database geoscrub
# to analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 23 May 2017 

### Contents


I. Overview
II. Requirements
III. Schema
IV.Usage  

### I. Overview

Script "countries.sh" copies geonames lookup table countries from database geoscrub to analytical database

### II. Requirements

Requires table countries in database geoscrub.

### III. Schema



### IV. Usage

```
$ ./countries.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


