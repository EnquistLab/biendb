# Updates analytical_stem with values from vfoi

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Usage

```
$ ./analytical_stem.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Strongly recommend running from "screen" session, as complete operation   
    takes several hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
