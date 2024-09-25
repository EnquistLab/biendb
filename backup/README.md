# Backup operations on BIEN database

NOTE: for next time, remove all $user parameters from all files and add:

su postgres

at start of script to run as superuser

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 3 May 2017

### Contents

I. Overview  
II. Requirements  
III. Warnings
IV. Usage  

### I. Overview

Performs partical and complete backups of BIEN databases. See individual scripts for details 

### III. Warnings

1. Database and schema parameters are set in section "Params" of main file, 
not in local params.sh file.

2. The user specified in params file must have USAGE on all schemas in the database, and SELECT privileges on all tables in all schemas. If this is not 
the case, log in as superuser and grant these privileges before running this sript.

### IV. Usage

Example. Backup of production schema for BIEN public analytical database:

```
$ ./backup_adb_public.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
