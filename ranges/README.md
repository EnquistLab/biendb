# Copies table "ranges" from "public_vegbien.public" to "vegbien.analytical_db_dev". 
# TEMPORARY FIX UNTIL I CAN RELOAD RANGES FROM SCRATCH"

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Copies table "ranges" from "public.public_vegbien" to "analytical_db_dev.vegbien"

### II. Requirements

Requires table "ranges" in schema "public" of database "public_vegbien".

### III. Usage

```
$ ./cp_ranges.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * -m switch sends start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
