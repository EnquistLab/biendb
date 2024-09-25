# Extracts and submits observations for processing by CULTOBS validation (CULTivated OBServations)

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview
CULTOBS
Extracts individual observation details from vfoi and agg_traits, submits to validation CULTOBS for detection of possible cultivated observations, and imports the results back to the source tables. Does this in three steps:

1. cultobs_1_prepare.sh. Extract all observations with non-null values of taxon, specimen and locality description fields, and latitude & longitude from vfoi and agg_traits and inserts to table cultobs_sumitted. Dumps contents of poldivs to the CULTOBS data directory.

2. cultobs_2_scruULsh. Processes observations with COBS application.

3. cultobs_3_update.sh. Imports COBS validation results and updates the relevant columns in vfoi and agg_traits.

These scripts are intended to be called from master script.

### III. Usage

1. Prepare cultobs_submitted 

```
$ ./cultobs_1_prepare.sh
```

2. Scrub cultobs_submitted. Also see CULTOBS application scripts.

```
$ ./cultobs_2_scrub.sh
```

3. Import CULTOBS results and update analytical tables

```
$ ./cultobs_3_update.sh
```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


