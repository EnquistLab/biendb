# Copy table world_geom from public to private analytical database 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 21 April 2017

### Contents

I. Overview  
II. Usage  

### I. Overview

Copies table world_geom from public analytical db (db public_vegbien, schema public) to private analytical db (db vegbien, schema analytical_db_dev).

This is a temp fix. Ultimately need to rebuild this table from scratch. Not currently part of main adb pipeline.

### II. Usage

```
$ ./world_geom.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  * Recommend run in unix screen, with -m option, as operation takes many hours.
  	
