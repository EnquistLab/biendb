# Populates nsr columns in table vfoi

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 24 Mar 2017 

### Contents

I.Usage  

### I. Usage

```
$ ./vfoi_nsr.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


