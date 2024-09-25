# Pipeline version of hotfix 4.0.3. Fixes issues with FIA plot codes. 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents


I. Overview  
II.Usage  

### I. Overview

Fixes non-unique plot code issue in legacy FIA data as imported by Aaron to BIEN 3.0 database. Concatenates state plus county with plot code to ensure plot codes are unique within county. This is as recommended by FIA in their own documentation. 

Temporary fix only. Should not be necessary once FIA has been reimported from scratch. 

### II. Usage

```
$ ./fix_fia.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

