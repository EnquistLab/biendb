# Performs pre- and post-processing for centroid validation

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 16 Nov 2017 

### Contents

I. Overview  
II. Dependencies  
III. Schema changes  
IV. Usage  

### I. Overview

Performs pre-processing and post-processing for centroid validation. Pre-processing: extracts CSV file of primary keys (taxonobservation_id), geocoordinates and political divisions from table vfoi. Post-processing: after  checking for known geographic centroids, imports results as table centroids and updates selected columns in vfoi.

CSV file is dumped to data directory, as specified in params file for this application.

See centroid app for details of centroid validation.

### II. Usage

Pre-processing:

```
$ ./centroids_1_prepare.sh
```

Post-processing:

```
$ ./centroids_2_update.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  