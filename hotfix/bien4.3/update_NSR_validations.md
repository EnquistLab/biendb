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

### NSR columns

* Dump these to separate tables, along with pkeys


#### vfoi
* Separate table for analytical_stem not needed; it shares pkey with vfoi

```
DROP TABLE IF EXISTS nsr_cols_vfoi_bien4_2_8;
CREATE TABLE nsr_cols_vfoi_bien4_2_8 AS 
SELECT taxonobservation_id, nsr_id, 
native_status_country, native_status_state_province, native_status_county_parish,
native_status, native_status_reason, native_status_sources, is_introduced,
is_cultivated_in_region, is_cultivated_taxon
FROM view_full_occurrence_individual
;

-- Add the minimum required indexes
ALTER TABLE nsr_cols_vfoi_bien4_2_8 ADD PRIMARY KEY (taxonobservation_id);
CREATE INDEX nsr_cols_vfoi_bien4_2_8_nsr_id_idx ON nsr_cols_vfoi_bien4_2_8 (nsr_id);
```

#### agg_traits

```
DROP TABLE IF EXISTS nsr_cols_agg_traits_bien4_2_8;
CREATE TABLE nsr_cols_agg_traits_bien4_2_8 AS 
SELECT id, nsr_id, 
native_status_country, native_status_state_province, native_status_county_parish,
native_status, native_status_reason, native_status_sources, is_introduced,
is_cultivated_in_region, is_cultivated_taxon
FROM agg_traits
;

-- Add the minimum required indexes
ALTER TABLE nsr_cols_agg_traits_bien4_2_8 ADD PRIMARY KEY (id);
CREATE INDEX nsr_cols_agg_traits_bien4_2_8_nsr_id_idx ON nsr_cols_agg_traits_bien4_2_8 (nsr_id);
```

## Step 2. Prepare observation extract

Carefully check parameters in:

```
/home/bien/biendb/params.sh
/home/bien/biendb/nsr/params.sh
/home/bien/biendb/nsr/params_override.sh
/home/bien/biendb/nsr/params_restore.sh
```

Then: 

```
cd /home/bien/biendb/nsr
screen
./nsr_1_prepare.sh -m
```

Note: `-m` option: send notification emails. Be sure to set parameter `email` in main params file.

## Step 3. Scrub observations with NSR

### Test scrub using small subset from main nsr_submitted file

(1) Extract small test dataset `bien_nsr_2024-10-18_test.csv`

```
cd /home/bien/nsr/data/user
head -11 bien_nsr_2024-10-18.csv > bien_nsr_2024-10-18_test.csv
```

(2) Temporarily set NSR input filename to `bien_nsr_2024-10-18_test.csv` by adding the following line to `params_override.sh`:

```
submitted_filename="bien_nsr_2024-10-18_test.csv"
```

(3) Scrub the test file with the NSR:

```
cd /home/bien/biendb/nsr
./nsr_2_scrub.sh
```

(4) Reset NSR input filename by deleting the line to `params_override.sh` in step 2 above.

(5) Scrub the full NSR input file:

```
cd /home/bien/biendb/nsr
screen
./nsr_2_scrub.sh -m
```

## Step 4. Import NSR results and update unindexed duplicate database tables

* Run version of nsr update script for use on live database
* Create duplicate copies of vfoi, analytical_stem and agg_traits instead of replacing tables
* Test first with a small sample of each table by setting SQL_LIMIT_LOCAL=" LIMIT 100 "
* If everything looks good, run at scale

```
./nsr_3_update_live.sh -m

```

## Step 5. Add minimum required indexes to updated vfoi and extract range model data





## Step 6. Fully index the new tables


## Step 7. Validate the tables


## Step 8. Activate new tables by renaming

* Rename the original tables by adding version suffix to each
* Remove "_new" suffix from new tables, thereby making them the current live tables

```

```

## Step. 9. Tidy up

* Drop temporary NSR tables

```
DROP TABLE IF EXISTS nsr_submitted; 
DROP TABLE IF EXISTS nsr_submitted_raw;
```

## Step 10. Update metadata

See separate script `update_metadata.sql`.







