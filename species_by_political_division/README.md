# Create & populates table species_by_political_division

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 24 Mar 2017 

### Contents

I. Overview  
II. Usage  

### I. Overview

Metadata table species_by_political_division contains all unique scrubbed_species_binomial x political division combinations from table vfoi. 

### II. Usage

```
$ ./species_by_political_division.sh
```

  * Operation will abort if any SQL fails
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


