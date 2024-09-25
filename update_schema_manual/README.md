# Changes major table schema independently of data build pipeline

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Run these scripts separately to change major table schemas at any time. Major tables are analytical tables that require "CREATE TABLE AS" method instead of "UPDATE" or "ALTER TABLE" due to large size. This allows you to add and remove columns while preserving all other columns and data.

Example use: Step 1 of pipeline has been run & you are awaiting results of TNRS to continue with step 2. Meanwhile, you decide to make changes to schemas of one or more major tables, changes that must be implemented in step 1. Assuming that all necessary code changes have been implemented in the pipeline, running this script on the affected tables will allow you to continue with Step 2 without have to re-run Step 1. This save time as Step 1 can take 30 hours or more.

### II. Usage

#### view_full_occurrence_individual:

```
$ ./update_schema_vfoi.sh
```
#### analytical_stem:

```
$ ./update_schema_astem.sh
```
#### agg_traits:

```
$ ./update_schema_agg_traits.sh
```



  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Run from "screen" session: complete operation takes >=60 hours.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


