# Submits political division to GNRS for validation and imports results

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Submits political division to GNRS for validation and imports results. Performs this in three steps:

1. gnrs_1_prepare.sh. Extract all unique political divisions from vfoi and agg_traits and inserts to table poldivs. Builds concatenated candidate PK column poldiv_full. Dumps contents of poldivs to the GNRS data directory.

2. gnrs_2_scrub.sh. Processes political divisions with GNRS.

3. gnrs_3_update.sh. Imports GNRS validation results and updates the relevant columns in vfoi and agg_traits.

These scripts are intended to be called from master script.

### III. Usage

1. Prepare political divisions from scrubbing 

```
$ ./gnrs_1_prepare.sh
```

2. Scrub with GNRS. See also application scripts.  

```
$ ./gnrs_2_scrub.sh
```

3. Import GNRS results and update analytical tables

```
$ ./gnrs_3_update.sh
```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


