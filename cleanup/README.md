# Final cleanup at end of private analytical db pipeline

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 5 April 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Removes temporary tables and renames development tables, removing "_dev" suffix.

### II. Requirements

Requires completed development analytical dababase.

### III. Usage

```
$ ./cleanup.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * -m switch sends start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
