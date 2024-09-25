# Import new data directly to analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Imports data dumps for new data sources and injects these directly into analytical database. Scripts for each source live within their own directory, named using short_name (code) for that datasource. Raw data for each source must be its own subdirectory inside the data directory: import/data/[source-short-name]/. Subdirectories are named using the code for the source. 

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
  	
