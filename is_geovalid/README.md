# Populate flag is_geovalid

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Populates flag is_geovalid. Provides a consensus validation of all geospatial & coordinate validations into a single yes/no/null column (0=no, 1=yes). Geovalid=1 mean that the observation's coordinates are (1) non-null, (2) valid (in domain, not in ocean), (3) within all resolved declared political divisions, and (4) not political division centroids. 


### II. Usage

```
$ ./is_geovalid_1_prepare.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  