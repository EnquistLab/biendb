# Executes hotfix specific to database version

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents


I. Overview  
II. Requirements  
III. Schema  
IV.Usage  
V. Warnings    

### I. Overview


### II. Usage

```
$ ./hotfix.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

### V. Warnings

Currently only copies tables to public database. Not yet implemented for private database.
