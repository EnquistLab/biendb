# Process taxa + political division with NSR (Native Species Resolver)

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  
III. Alternative usage (live database)

### I. Overview

Submits taxon names plus political division to NSR for validation and imports results. Performs this in three steps:

1. `nsr_1_prepare.sh`. Extract all unique taxon names + political divisions from vfoi and agg\_traits and inserts to table nsr\_submitted\_raw. Builds concatenated candidate PK column taxon\_poldiv in new table nsr\_submitted. Dumps contents of nsr\_submitted to the NSR data directory.

2. Process political divisions with NSR (this step handled separately on separate server; local processing with scripts `nsr_2_update.sh` under construction)

3. `nsr_3_update.sh`. Imports NSR validation results and updates the relevant columns in vfoi and agg\_traits.

These scripts are intended to be called from master script.

### II. Usage 
* Normal usage as part of complete BIEN DB pipeline when building new database.

1. Prepare political divisions for scrubbing: 
  
  ```
  $ ./nsr_1_prepare.sh
  ```
2. Process prepared political divisions with NSR:

   ```
	$ ./nsr_2_scrub.sh
	
	```
3. Import NSR results and update analytical tables:

	```
	$ ./nsr_3_update.sh
	```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

### III. Alternative usage (live database)
* Alternative usage as standalone operation when refreshing NSR fields only in a production (live) database.
* Typical use case would be to update NSR fields in BIEN database after a rebuild/refresh/refactor of the NSR

1. Set local parameters as needed in `params_override.sh`.

2. Prepare political divisions for scrubbing 
	
	```
	$ ./nsr_1_prepare.sh
	```

3. Process directly with NSR. See separate application repository (`/home/bien/nsr`).

4. Import NSR results and update analytical tables

	```
	$ ./nsr_3_update_live.sh
	
	```
