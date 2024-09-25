# CODS: Cultivated Observation Detection Service

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Flags observations which are likely to be cultivated plants, as determined by (1) proximity to herbaria or botanical gardens, (2) presence of key words in locality or specimen description indicating occurrence in plantations, gardens, etc. 
These scripts are intended to be called from master script.

### III. Usage

1. Extract data for processing by CODS.

```
$ ./cods_1_prepare.sh
```

2. Import CODS results and update analytical tables 

```
$ ./cods_3_update.sh
```

  * Operation will abort if any SQL fails
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


