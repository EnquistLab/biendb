# Uses CREATE TABLE AS method to alter the major adb tables  

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

This step provides a last opportunity to alter schemas (or contents) of the 
three major adb tables. Comment out any tables for which no changes needed,  
or remove the call to this script entirely if no changes needed.

### II. Usage

```
$ ./update_schema.sh
```

  * Operation will abort if any SQL fails
  * If running standalone, use -m switch to generate start, stop and   
  	error emails. Valid email must be provided in main params.sh.
  * Recommend run from "screen" session
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


