# Create all remaining indexes on major adb tables  

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Adds primary key constraints and indexes to the major adb tables.

### II. Usage

```
$ ./restore_indexes.sh
```

  * Operation will abort if any SQL fails
  * If running standalone, use -m switch to generate start, stop and   
  	error emails. Valid email must be provided in main params.sh.
  * Recommend run from "screen" session
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


