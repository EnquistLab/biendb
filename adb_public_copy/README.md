# Copies private analytical database from vegbien.analytical_db_dev to public_vegbien.analytical_db_dev and applies public database embargoes.

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 21 April 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  
IV. Notes 

### I. Overview

Copies private analytical database from vegbien.analytical_db_dev to public_vegbien.analytical_db_dev.

### II. Requirements  

Completed full analytical database must be present in private database.

### III. Usage

```
$ ./adb_public_copy.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  * Recommend run in unix screen, with -m option, as operation takes many hours.
  	
### IV. Notes 

Dumpfile is edited prior to restore, changing schema references for spatial tables from postgis (separate spatial reference schema used in vegbien) to public (where spatial tables are kept along with rest of database).

