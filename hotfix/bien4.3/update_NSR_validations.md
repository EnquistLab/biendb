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


