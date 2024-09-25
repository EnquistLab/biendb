# Process taxa + political division with NSR (Native Species Resolver)

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Submits taxon names plus political division to NSR for validation and imports results. Performs this in three steps:

1. nsr_1_prepare.sh. Extract all unique taxon names + political divisions from vfoi and agg_traits and inserts to table nsr_submitted_raw. Builds concatenated candidate PK column taxon_poldiv in new table nsr_submitted. Dumps contents of nsr_submitted to the NSR data directory.

2. Process political divisions with NSR (this step handled separately on separate server; local processing with scripts nsr_2_update.sh under construction)

3. nsr_3_update.sh. Imports NSR validation results and updates the relevant columns in vfoi and agg_traits.

These scripts are intended to be called from master script.

### III. Usage

1. Prepare political divisions from scrubbing 

```
$ ./nsr_1_prepare.sh
```

2. Process with NSR. See separate application repository.

3. Import NSR results and update analytical tables

```
$ ./nsr_3_update.sh
```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


