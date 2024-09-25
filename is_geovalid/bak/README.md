# Performs pre- and post-processing for point-in-polygon geovalidation

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Performs pre-processing and post-processing for point-in-polygon geovalidation. Pre-processing: extracts CSV file of primary keys (taxonobservation_id), geocoordinates and political divisions from table vfoi. Post-processing: after  checking for known geographic centroids, imports results as table geovalid and updates selected columns in vfoi & agg_traits.

CSV file is dumped to data directory, as specified in params file for this application.

See centroid app for details of centroid validation.

### II. Usage

Pre-processing:

```
$ ./geovalid_1_prepare.sh
```

Post-processing:

```
$ ./geovalid_2_update.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  