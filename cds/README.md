# Submits political division to CDS for validation and imports results

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Submits geocoordinates to CDS for validation, and imports results. Performs this in three steps:

1. CDS_1_prepare.sh. Extract all unique coordinates from vfoi and agg_traits and inserts to table poldivs. Builds concatenated candidate PK column poldiv_full. Dumps contents of poldivs to the CDS data directory.

2. CDS_2_scrub.sh. Processes coordinates with CDS.

3. CDS_3_update.sh. Imports CDS validation results and updates the relevant columns in vfoi and agg_traits.

These scripts are intended to be called from master script.

### III. Usage

1. Prepare coordinates for scrubbing 

```
$ ./cds_1_prepare.sh
```

2. Scrub with CDS. See also application scripts.  

```
$ ./cds_2_scrub.sh
```

3. Import CDS results and update analytical tables

```
$ ./cds_3_update.sh
```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


