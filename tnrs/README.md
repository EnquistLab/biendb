# Performs pre- and post-processing for TNRSbatch application 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Steps  
III. Usage  

### I. Overview  

Extracts and prepares taxon names for processing using TNRS batch processing application. After batch processing, imports results, performs post-processing and updates analytical database. 

Pre- and post-processing are performed as separate operations, between which taxon names are processed in separate step using TNRS_BATCH application. BIEN pipeline must therefore be broken to allow batch processing to be performed. 

Application TNRSbatch, developed by Naim Matasci, is a separate application from the online TNRS. It accesses the same core TNRS service (GNI name parse and Taxamatch) but returns results in a somewhat different format from the online TNRS. TNRSbatch allows multi-threaded batch processing using the Makeflow Workflow System (http://ccl.cse.nd.edu/software/makeflow/). For details of TNRSbatch, see https://github.com/nmatasci/TNRSbatch.

### II. Steps  

1. (tnrs_batch_1_prepare.sh). Extract taxon names from BIEN database and pre-process
 * Selects all distinct taxon names from BIEN database
 * Perform pre-processing, correcting errors currently not handled or not handled well by the TNRS core services and removing any characters known to cause crashes or other issues
 * Export prepared extract to TNRS data directory

2. (not part of BIEN pipeline). Process prepared extract with TNRSbatch application  and dump results to TNRS data directory

3. (tnrs_batch_2_update.sh). Import TNRS results, post-process and update to BIEN database
 * Import TNRSbatch results from TNRS data directory
 * Perform post-processing, including selecting best match
 * Update TNRS columns in all BIEN analytical db tables

### III. Usage  

1. Extract taxon names and pre-process:  

```
$ ./tnrs_batch_1_prepare.sh [options]
```

2. Import results, post-process and update BIEN database:  

```
$ ./tnrs_batch_2_update.sh [options]
```

* Options:  
	-m: Send notification emails  
	-s: Silent mode  


