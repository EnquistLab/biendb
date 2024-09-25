# Moves private and public analytical schemas to production in single operation

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Warnings  
IV. Usage  

### I. Overview

Moves development private and public analytical databases to production in following steps:

1. Renames current production schema by adding '_' plus database version number as suffix
2. Renames development schema to production schema by removing '_dev' suffix from schema name.

Schemas are renamed as follows:

| Private or public | Database | Development schema | Production schema
| ----------------- | -------- | ------------------ | -----------------
| private | vegbien | analytical_db_dev | analytical_db
| private | vegbien | users_dev | users
| private | public_vegbien | analytical_db_dev | public

### II. Requirements

All production and development versions of private and public analytical, named as above.

### III. Warnings

Run full backup of of all schemas prior to running this script. Strongly recommend full postgres backup.

### IV. Usage

```
$ ./move_to_production.sh 

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
