# Update all NSR validation fields in BIEN DB

## Overview

The NSR database was refreshed in September 2024 (v3.0) to incoporate updates to many of its checklist sources, most importantly "Plants of the World Online" (powo). This readme documents the subsequent steps taken to update NSR validation fields for all observations in the BIEN DB (version 4.2.8 prior to update, 4.3 afterward).

## Step 1. Backup existing NSR table & columns

### Table nsr
* Rename instead of copying:

```
\c vegbien
SET search_path TO analytical_db;

ALTER TABLE nsr RENAME TO nsr_bien4_2_8;
```


## Step 2. Extract observations for scrubbing with NSR

### (i) Setup

Carefully check parameters in:

```
/home/bien/biendb/params.sh
/home/bien/biendb/nsr/params.sh
/home/bien/biendb/nsr/params_override.sh
/home/bien/biendb/nsr/params_restore.sh
```

Important: in `params_override.sh`, set a custom name for the NSR input file by appending the date (bien\_nsr\_<TODAYS_DATE>.csv) as follows: 

```
submitted_filename_orig=$submitted_filename
submitted_filename="bien_nsr_2024-10-18.csv"
```

### (ii) Extract the observations
* Best sure to run in screen

```
cd /home/bien/biendb/nsr
screen
./nsr_1_prepare.sh -m
```

Note: `-m` option: send notification emails. Be sure to set parameter `email` in main params file.

## Step 3. Scrub observations with NSR

### (i) Test scrub using small subset from main nsr_submitted file

***(a) Extract small test dataset `bien_nsr_2024-10-18_test.csv`***

```
cd /home/bien/nsr/data/user
head -11 bien_nsr_2024-10-18.csv > bien_nsr_2024-10-18_test.csv
```

***(b) Temporarily set NSR input and output filenames to `bien_nsr_2024-10-18_test.csv` in`params_override.sh`:***

```
submitted_filename_orig=$submitted_filename
submitted_filename="bien_nsr_2024-10-18_test.csv"

results_filename_orig=$results_filename
results_filename="bien_nsr_2024-10-18_test_nsr_results.tsv"
```

***(c) Scrub the test file with the NSR:***

```
cd /home/bien/biendb/nsr
./nsr_2_scrub.sh
```

***(d) Reset NSR input & output filenames in `params_override.sh`***

```
submitted_filename_orig=$submitted_filename
submitted_filename="bien_nsr_2024-10-18.csv"

results_filename_orig=$results_filename
results_filename="bien_nsr_2024-10-18_nsr_results.tsv"
```

### (ii) Scrub the full NSR input file
* Run in screen
* Include notification option `-m`.

```
cd /home/bien/biendb/nsr
screen
./nsr_2_scrub.sh -m
```


## Step 4. Import NSR results to unindexed *duplicate* database tables

* Run version of nsr update script for use on live database (`nsr_3_update_live.sh`).
* This creates duplicate copies of vfoi, analytical\_stem and agg\_traits instead of replacing tables, by adding `_new` suffix, as follows:

  `view_full_occurrence_individual_new`  
  `agg_traits_new`  
  `analytical_stem_new`  
  
### (i) Test run
* Use small sample of each table by setting the following parameter in `params.sh`:
  
  ```
  SQL_LIMIT_LOCAL=" LIMIT 100 "
  ```
* Run the update:
  
  ```
  ./nsr_3_update_live.sh
  ```
* Check results in BIEN database. Should see the three new tables shown above, with 100 records each.
* If everything looks good, execute full production run.

###(ii) Production run
* Set SQL limit parameters in `params.sh`:
  
  ```
  SQL_LIMIT_LOCAL=" "
  ```
  
* Run the full update:

	```
	screen
	./nsr_3_update_live.sh -m
	```

## Step 5. Fully index the new tables
* Run custom indexing script `restore_indexes_new.sh` in biendb module directory `restore_indexes`
* Adds indexes to the three new tables (with suffix "_new") created in Step 4.
* This operation takes a long time; be sure to run in screen with email notification

```
cd /home/bien/biendb/src/restore_indexes
screen
./restore_indexes_new.sh -m
```


## Step 6. Adjust ownership of updated tables
* Uses scripts in biendb module `set_permissions`
* Currently tables are owned by user bien but do not have explicit access permissions
* Run from Postgres SQL command line, in production BIEN schema
* Goals:
  * Make sure user `bien` has all privileges on all tables, including tables, views and sequences created in future
  * Grant select on all tables to roles `bien_private` and `public_bien3`, including future tables, views and sequences.

### (i) Setup
* Make sure the following parameters in `set_permissions/params.sh` are set as shown below:


```
db=$db_private
sch="analytical_db"

users_select="
bien_private
public_bien3
"

users_full="
bien
"
```

### (ii) Execute
* Just run as your regular user, script will execute under postgres user 'bien', which as adequate permissions
* Do NOT run as postgres (will throw errors)

```
cd /home/bien/biendb/src/set_permissions
./set_permissions.sh
```

## Step 7. Move updated tables to production
* Archive the original tables by adding version suffix to each
* Make the new tables available by restoring the original names (i.e., renaming by removing "_new" suffix)
* Run from Postgres SQL command line, in production BIEN schema
* Run the renames for each pair of tables together, to minimize downtime for the production table.
* Wrap each pair of name changes in a transaction to avoid conflicts with other processes

```
-- vfoi
BEGIN;
ALTER TABLE view_full_occurrence_individual RENAME TO view_full_occurrence_individual_4_2_8;
ALTER TABLE view_full_occurrence_individual_new RENAME TO view_full_occurrence_individual;
COMMIT;

-- agg_traits
BEGIN;
ALTER TABLE agg_traits RENAME TO agg_traits_4_2_8;
ALTER TABLE agg_traits_new RENAME TO agg_traits;
COMMIT;

-- astem
BEGIN;
ALTER TABLE analytical_stem RENAME TO analytical_stem_4_2_8;
ALTER TABLE analytical_stem_new RENAME TO analytical_stem;
COMMIT;

```

## Step 8. Rename indexes in updated tables
* Indexes on the updated tables incude suffix "_new". This should be removed so that the index names are as inspected
* If do not rename, any future operations that involved dropping and rebuilding indexes will fail
* Run the following scripts in the `manual_operations` folder of biendb module `restore_indexes`:

```
cd /home/bien/biendb/src/restore_indexes/manual_operations 
sudo -u postgres psql -f analytical_stem_new_rename_indexes.sql
sudo -u postgres psql -f agg_traits_new_rename_indexes.sql
sudo -u postgres psql -f vfoi_new_rename_indexes.sql
```

## Step. 7. Tidy up

* Drop temporary NSR tables

```
DROP TABLE IF EXISTS nsr_submitted; 
DROP TABLE IF EXISTS nsr_submitted_raw;
```

## Step 8. Update metadata

See separate script `update_metadata.sql`.

## Notes
* After database has been working satisfactorily for a while, you may wish to drop the old (archived) tables, as these are very large.







