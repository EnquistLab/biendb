# Populate missing NSR is_cultivated flags

## Key facts
* Part of BIEN DB hotfix 4.2.1
* No changes to BIEN DB pipeline needed, issue was with NSR and will be fixed in next import
* * Do this TWICE! Once for private db and once for public db

## Overview

In BIEN 4.2 Maitner et al reported that columns is\_cultivated\_taxon and is\_cultivated\_in\_region are all zeros (i.e., default values, not populated). Troubleshooting confirmed that issue is with NSR, not BIEN DB. Actually, two issues:

1. is\_cultivated\_taxon: table cultspp not populated. Not sure why this happened, but as temporary fix populated this table with contents of the same table from a previous version of the NSR DB. No enough time to fully troubleshoot, but added runtime warning to NSR DB pipeline to investigate before running next NSR DB build.
2. is\_cultivated\_in\_region (=isCultivatedNSR in NSR output): table cultspp not populated AND queries needed to populate this field not implemented. I added them to the NSR pipeline, updated remote repo and updated production version from remote.

Both fields are now populated correctly by the NSR. No changes to BIEN DB pipeline are required, but manual updates required (see below) to fix BIEN DB before next full DB rebuild. 

## Solution

This solution populates columns is\_cultivated\_taxon and is\_cultivated\_in\_region in existing NSR results table nsr. It does not include the final updates to tables vfoi and agg_traits.

### Extract nsr_submitted & dump to filesystem
* In postgres

```
\c vegbien
set search_path to analytical_db;
DROP TABLE OF EXISTS nsr_submitted;
CREATE TABLE nsr_submitted AS
SELECT DISTINCT
taxon_poldiv,
species AS taxon,
country,
state_province,
county_parish
FROM nsr
;
COPY nsr_submitted to '/tmp/nsr_submitted' CSV HEADER;
```

### Import nsr_submitted to MySQL NSR db and update 
* in shell

```
mv /tmp/nsr_submitted /home/boyle/bien/nsr/data/user/nsr_submitted_20210618.csv
cd /home/boyle/bien/nsr/data/user
head -10000 nsr_submitted_20210618.csv > nsr_submitted_20210618.sample.csv
```

* in MySQL
* Load file nsr_submitted_20210618.sample.csv to test first

```
use nsr_dev;
drop table if exists nsr_submitted_temp;
create table nsr_submitted_temp (
taxon_poldiv VARCHAR(250),
species VARCHAR(250),
country VARCHAR(250),
state_province VARCHAR(250) DEFAULT NULL,
county_parish VARCHAR(250) DEFAULT NULL
);
LOAD DATA LOCAL INFILE '/home/boyle/bien/nsr/data/user/nsr_submitted_20210618.csv'
INTO TABLE nsr_submitted_temp 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
;
UPDATE nsr_submitted_temp 
SET state_province=NULL
WHERE TRIM(state_province)=''
;
UPDATE nsr_submitted_temp 
SET county_parish=NULL
WHERE TRIM(county_parish)=''
;
ALTER TABLE nsr_submitted_temp
ADD COLUMN user_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST,
ADD COLUMN is_cultivated_taxon INTEGER DEFAULT 0,
ADD COLUMN is_cultivated_in_region INTEGER DEFAULT 0
;
CREATE INDEX nsr_submitted_temp_species_idx
ON nsr_submitted_temp (species)
;
CREATE INDEX nsr_submitted_temp_country_idx
ON nsr_submitted_temp (country)
;
CREATE INDEX nsr_submitted_temp_state_province_idx
ON nsr_submitted_temp (state_province)
;
CREATE INDEX nsr_submitted_temp_county_parish_idx
ON nsr_submitted_temp (county_parish)
;

--
-- Update is_cultivated_taxon
--

UPDATE nsr_submitted_temp o JOIN cultspp c
ON o.species=c.taxon
SET o.is_cultivated_taxon=1
;

--
-- Update is_cultivated_in_region
--

-- county
UPDATE nsr_submitted_temp o JOIN distribution d
ON o.species=d.taxon
AND o.country=d.country
AND o.state_province=d.state_province
AND o.county_parish=d.county_parish
SET o.is_cultivated_in_region=1
WHERE d.cult_status='cultivated'
;

-- state
UPDATE nsr_submitted_temp o JOIN distribution d
ON o.species=d.taxon
AND o.country=d.country
AND o.state_province=d.state_province
SET o.is_cultivated_in_region=1
WHERE d.cult_status='cultivated'
;

-- country
UPDATE nsr_submitted_temp o JOIN distribution d
ON o.species=d.taxon
AND o.country=d.country
SET o.is_cultivated_in_region=1
WHERE d.cult_status='cultivated'
;

```

### Dump NSR results to filesystem
* In MySQL:

```

 SHOW VARIABLES LIKE "secure_file_priv";
+------------------+-----------------------+
| Variable_name    | Value                 |
+------------------+-----------------------+
| secure_file_priv | /var/lib/mysql-files/ |
+------------------+-----------------------+
1 row in set (0.07 sec)

select * from nsr_submitted_temp
INTO OUTFILE '/var/lib/mysql-files/nsr_is_cultivated.tsv'
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';
```

* In shell:

```
	sudo mv /var/lib/mysql-files/nsr_is_cultivated.tsv /home/boyle/bien/nsr/data/user/
cd /home/boyle/bien/nsr/data/user/
sed -i 's/\\N//g' nsr_is_cultivated.tsv
```

### Import NSR results to BIEN DB and update original columns in table nsr
* In postgres

```
\c vegbien
set search_path to analytical_db;
DROP TABLE IF EXISTS nsr_is_cultivated;
CREATE TABLE nsr_is_cultivated (
user_id integer,
taxon_poldiv text,
species text,
country text,
state_province text,
county_parish text,
is_cultivated_taxon integer,
is_cultivated_in_region integer
);
COPY nsr_is_cultivated FROM '/home/boyle/bien/nsr/data/user/nsr_is_cultivated.tsv'
with delimiter E'\t' null as '';

-- Index the join field
CREATE INDEX nsr_is_cultivated_taxon_poldiv_idx 
ON nsr_is_cultivated (taxon_poldiv)
;

-- Update the original fields
UPDATE nsr a
SET is_cultivated_taxon=b.is_cultivated_taxon,
is_cultivated_in_region=b.is_cultivated_in_region
FROM nsr_is_cultivated b
WHERE a.taxon_poldiv=b.taxon_poldiv
;

-- Some checks
SELECT species, country, is_cultivated_taxon, is_cultivated_in_region
from nsr
where is_cultivated_taxon='1'
limit 12
;
SELECT species, country, is_cultivated_taxon, is_cultivated_in_region
from nsr
where is_cultivated_in_region='1'
limit 12
;
select is_cultivated_taxon, count(*) from nsr group by is_cultivated_taxon;
select is_cultivated_in_region, count(*) from nsr group by is_cultivated_in_region;

```

### Tidy up

In Postgres:

```
drop table nsr_submitted;
drop table nsr_is_cultivated;

```

In MySQL:

```
use nsr_dev;
drop table nsr_submitted_temp;
```

In shell:

```
cd /home/boyle/bien/nsr/data/user
rm nsr_is_cultivated.tsv
rm nsr_submitted_20210618.csv
rm nsr_submitted_20210618.sample.csv
```


## Add PK & indexes to table nsr

```
\c vegbien
set search_path to analytical_db
ALTER TABLE nsr
ADD PRIMARY KEY (id)
;
CREATE INDEX nsr_is_cultivated_taxon_idx ON nsr (is_cultivated_taxon);
CREATE INDEX nsr_is_cultivated_in_region_idx ON nsr (is_cultivated_in_region);

```

## Update analytical tables

* see script `bien4.2.1_update_nsr_is_cultivated_columns.sh` in module `custom/`.

## Final checks

```
-- Some checks

\c vegbien
set search_path to analytical_db;

SELECT scrubbed_species_binomial 
FROM view_full_occurrence_individual
WHERE is_cultivated_taxon=1
LIMIT 12
;

SELECT scrubbed_species_binomial, country, state_province
FROM view_full_occurrence_individual
WHERE is_cultivated_in_region =1
LIMIT 12
;


SELECT is_cultivated_taxon, is_cultivated_in_region, count(*)
from agg_traits
group by is_cultivated_taxon, is_cultivated_in_region
;

SELECT is_cultivated_taxon, is_cultivated_in_region, count(*)
from analytical_stem
group by is_cultivated_taxon, is_cultivated_in_region
;

SELECT is_cultivated_taxon, is_cultivated_in_region, count(*)
from view_full_occurrence_individual
group by is_cultivated_taxon, is_cultivated_in_region
;
```


## Set new DB minor version to 4.2.1

```
\c vegbien
set search_path to analytical_db;
drop table if exists nsr_is_cultivated;
create table nsr_is_cultivated as
select id, taxon_poldiv, is_cultivated_in_region, is_cultivated_taxon
from nsr
;
copy nsr_is_cultivated to 
'/tmp/nsr_is_cultivated.csv' csv header;

\c public_vegbien
drop table if exists nsr_is_cultivated;
create table nsr_is_cultivated (
id bigint, 
taxon_poldiv text, 
is_cultivated_in_region integer, 
is_cultivated_taxon integer
);
copy nsr_is_cultivated from '/tmp/nsr_is_cultivated.csv' DELIMITER ','
CSV HEADER; 

-- Index the join field
CREATE INDEX nsr_is_cultivated_taxon_poldiv_idx 
ON nsr_is_cultivated (taxon_poldiv)
;

-- Update the original fields
UPDATE nsr a
SET is_cultivated_taxon=b.is_cultivated_taxon,
is_cultivated_in_region=b.is_cultivated_in_region
FROM nsr_is_cultivated b
WHERE a.taxon_poldiv=b.taxon_poldiv
;

```

## Finish up

* Run script `bien4.2.1_update_nsr_is_cultivated_columns.sh` in module `custom/`, after setting db=public_vegbien and schema=public
* Update bien_metadata, as above

