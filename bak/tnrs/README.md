# Imports TNRS results & performs post-processing

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 15 Oct 2017 

### Contents

I. Overview  
II. Dependencies  
III. Schema changes  
IV. Usage  

### I. Overview

Import TNRS results and performs post-processing

### II. Dependencies

The following files must be present in the data directory:

taxon_verbatim_parsed.txt - download of parsed names from TNRS website
taxon_verbatim_scrubbed.txt - download of resolved names from TNRS website

### III. Usage

```
$ ./tnrs.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


