# Import new data directly to analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 21 Aug 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Imports data dumps for new data sources and injects these directly into analytical database. Scripts for each source live within their own directory, named using short_name (code) for that datasource. These scripts assume that data have already been imported to postgres and are in their own schema in vegbien, schema name is also the source's code. A separate script to import the raw data to postgres is also in this directory. Raw data for each source is its own subdirector inside the data directory: import/data/[source-short-name]/.  Subdirectories are again named using the code for the source. 

### II. Requirements


### III. Usage

```
$ ./import.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from UNIX "screen" session
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
