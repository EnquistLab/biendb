-- ---------------------------------------------------------------
-- Repair tables gnrs, vfoi and agg_traits after introducting
-- duplicates from GNRS output
--
-- BIEN DB 4.2. Implemented during initial construction of DB, as 
-- part of pipeline step 2. Pipeline was also fixed: Qy4 and 
-- PK-unique check on table gnrs added to module GNRS. Also added
-- PK-unique check to table cds
-- ---------------------------------------------------------------

set search_path to analytical_db_dev;

-- 
-- Fix gnrs
-- 

-- Qy1
DROP TABLE IF EXISTS gnrs_nonuinque_bak;
-- Qy2
CREATE TABLE gnrs_nonuinque_bak (LIKE gnrs INCLUDING ALL);
INSERT INTO gnrs_nonuinque_bak SELECT * FROM gnrs;

-- Qy3
DROP TABLE IF EXISTS gnrs_temp;
-- Qy4: Also added gnrs/sql/gnrs_make_unique.sql
CREATE TABLE gnrs_temp AS
SELECT DISTINCT 
poldiv_full,
CASE WHEN TRIM(COALESCE(country_verbatim,''))='' THEN NULL ELSE country_verbatim END AS country_verbatim,
CASE WHEN TRIM(COALESCE(state_province_verbatim,''))='' THEN NULL ELSE state_province_verbatim END AS state_province_verbatim,
CASE WHEN TRIM(COALESCE(state_province_verbatim_alt,''))='' THEN NULL ELSE state_province_verbatim_alt END AS state_province_verbatim_alt,
CASE WHEN TRIM(COALESCE(county_parish_verbatim,''))='' THEN NULL ELSE county_parish_verbatim END AS county_parish_verbatim,
CASE WHEN TRIM(COALESCE(county_parish_verbatim_alt,''))='' THEN NULL ELSE county_parish_verbatim_alt END AS county_parish_verbatim_alt,
CASE WHEN TRIM(COALESCE(country,''))='' THEN NULL ELSE country END AS country,
CASE WHEN TRIM(COALESCE(state_province,''))='' THEN NULL ELSE state_province END AS state_province,
CASE WHEN TRIM(COALESCE(county_parish,''))='' THEN NULL ELSE county_parish END AS county_parish,
country_id,
state_province_id,
county_parish_id,
country_iso,
state_province_iso,
county_parish_iso,
geonameid,
gid_0,
gid_1,
gid_2,
match_method_country,
match_method_state_province,
match_method_county_parish,
match_score_country,
match_score_state_province,
match_score_county_parish,
poldiv_submitted,
poldiv_matched,
match_status
FROM gnrs
;

-- Check unique (has_dupes='f')
SELECT EXISTS (
SELECT poldiv_full, COUNT(*) FROM gnrs_temp GROUP BY poldiv_full HAVING COUNT(*)>1
) AS has_dupes;

-- If unique, continue continue restoring all indexes
DROP TABLE gnrs;
ALTER TABLE gnrs_temp RENAME TO gnrs;
ALTER TABLE GNRS
ADD COLUMN id SERIAL NOT NULL;
ALTER TABLE gnrs DROP CONSTRAINT IF EXISTS gnrs_pkey;	
ALTER TABLE gnrs ADD PRIMARY KEY (id);	
CREATE INDEX  gnrs_poldiv_full_idx ON gnrs (poldiv_full);
CREATE INDEX  gnrs_country_verbatim_idx ON gnrs (country_verbatim);
CREATE INDEX  gnrs_state_province_verbatim_idx ON gnrs (state_province_verbatim);
CREATE INDEX  gnrs_county_parish_verbatim_idx ON gnrs (county_parish_verbatim);
CREATE INDEX  gnrs_country_idx ON gnrs (country);
CREATE INDEX  gnrs_state_province_idx ON gnrs (state_province);
CREATE INDEX  gnrs_county_parish_idx ON gnrs (county_parish);
CREATE INDEX  gnrs_match_method_state_province_idx ON gnrs (match_method_state_province);
CREATE INDEX  gnrs_match_method_county_parish_idx ON gnrs (match_method_county_parish);
CREATE INDEX  gnrs_poldiv_submitted_idx ON gnrs (poldiv_submitted);
CREATE INDEX  gnrs_poldiv_matched_idx ON gnrs (poldiv_matched);
CREATE INDEX  gnrs_match_status_idx ON gnrs (match_status);
CREATE INDEX gnrs_geonameid_idx ON gnrs (geonameid);
CREATE INDEX gnrs_gid_0_idx ON gnrs (gid_0);
CREATE INDEX gnrs_gid_1_idx ON gnrs (gid_1);
CREATE INDEX gnrs_gid_2_idx ON gnrs (gid_2);
CREATE INDEX gnrs_country_iso_idx ON gnrs (country_iso);
CREATE INDEX gnrs_state_province_iso_idx ON gnrs (state_province_iso);
CREATE INDEX gnrs_county_parish_iso_idx ON gnrs (county_parish_iso);

--
-- Fix agg_traits
--

-- Backup
DROP TABLE IF EXISTS agg_traits_nonuinque_bak;
-- Do not include indexes
CREATE TABLE agg_traits_nonuinque_bak (LIKE agg_traits);
INSERT INTO agg_traits_nonuinque_bak SELECT * FROM agg_traits;

-- Confirm that no null values of fk_gnrs_id exists
-- This MUST return 0 for remaining steps to work!
select count(*) from agg_traits where fk_gnrs_id is null;
/*
 count 
-------
     0
(1 row)
*/

-- Add temporary unique id (PK) & keep flag
-- Ensure NO indexes on vfoi before do this
-- SLOW
ALTER TABLE agg_traits
ADD COLUMN temp_PK SERIAL PRIMARY KEY,
ADD COLUMN keep smallint DEFAULT NULL
;

-- Extract unique combos of id + temp_pk
DROP TABLE IF EXISTS agg_traits_unique_ids_temp;
CREATE TABLE agg_traits_unique_ids_temp AS
SELECT
id, MIN(temp_pk) as temp_pk_min 
FROM agg_traits
GROUP BY id
;
ALTER TABLE agg_traits_unique_ids_temp 
ADD PRIMARY KEY (temp_pk_min); 

-- Update the keep flag (SLOW) & index it
UPDATE agg_traits a
SET keep=1
FROM agg_traits_unique_ids_temp b
WHERE a.temp_pk=b.temp_pk_min
;
CREATE INDEX agg_traits_keep_idx ON agg_traits(keep);

-- Confirm that counts match. MUST equal 't'!
SELECT 
( 
SELECT COUNT(*) FROM agg_traits WHERE keep IS NOT NULL
) = 
( 
SELECT COUNT(*) FROM agg_traits_unique_ids_temp 
) 
AS counts_match
; 

-- Delete the superfluous records
DELETE FROM agg_traits
WHERE keep IS NULL
;

-- Now the two tables should be equal (count_match='t')
SELECT 
( SELECT COUNT(*) FROM agg_traits ) = 
( SELECT COUNT(*) FROM agg_traits_unique_ids_temp ) 
AS counts_match
; 


-- Tidy up
DROP TABLE agg_traits_unique_ids_temp;
ALTER TABLE agg_traits DROP COLUMN temp_pk;
ALTER TABLE agg_traits DROP COLUMN keep;

-- Final test. MUST return 0!
SELECT COUNT(*) AS duplicate_agg_traits_id FROM (
SELECT id, COUNT(*) FROM agg_traits GROUP BY id HAVING COUNT(*)>1
) a;

--
-- Fix vfoi
--

-- Backup
DROP TABLE IF EXISTS view_full_occurrence_individual_dev_nonuinque_bak;
-- Do not include indexes
CREATE TABLE view_full_occurrence_individual_dev_nonuinque_bak (LIKE view_full_occurrence_individual_dev);
INSERT INTO view_full_occurrence_individual_dev_nonuinque_bak SELECT * FROM view_full_occurrence_individual_dev;

-- Add temporary unique id (PK) & keep flag
-- Ensure NO indexes on vfoi before do this
-- SLOW
ALTER TABLE view_full_occurrence_individual_dev
ADD COLUMN temp_PK SERIAL PRIMARY KEY,
ADD COLUMN keep smallint DEFAULT NULL
;
-- Time: 4802431.368 ms (01:20:02.431)

-- Extract unique combos of id + temp_pk
DROP TABLE IF EXISTS vfoi_unique_ids_temp;
CREATE TABLE vfoi_unique_ids_temp AS
SELECT
taxonobservation_id, MIN(temp_pk) as temp_pk_min 
FROM view_full_occurrence_individual_dev
GROUP BY taxonobservation_id
;
-- Time: 1099982.992 ms (18:19.983)
ALTER TABLE vfoi_unique_ids_temp 
ADD PRIMARY KEY (temp_pk_min); 
-- 	Time: 396623.788 ms (06:36.624)

-- Update the keep flag (SLOW) & index it
-- If this is too slow, use CREATE TABLE AS method (see
-- separate script vfoi_update_keep_create_table_as.sql
UPDATE view_full_occurrence_individual_dev a
SET keep=1
FROM vfoi_unique_ids_temp b
WHERE a.temp_pk=b.temp_pk_min
;
-- Time: 51107250.936 ms (14:11:47.251)
CREATE INDEX vfoi_keep_idx ON view_full_occurrence_individual_dev(keep);
-- Time: 2609906.758 ms (43:29.907)

-- Confirm that counts match. MUST equal 't'!
SELECT 
( 
SELECT COUNT(*) FROM view_full_occurrence_individual_dev WHERE keep IS NOT NULL
) = 
( 
SELECT COUNT(*) FROM vfoi_unique_ids_temp 
) 
AS counts_match
; 
-- Time: 2676357.043 ms (44:36.357)

-- Delete the superfluous records
DELETE FROM view_full_occurrence_individual_dev
WHERE keep IS NULL
;
-- DELETE 14563910
-- Time: 114216.376 ms (01:54.216)

-- Now the two tables should be equal (count_match='t')
SELECT 
( SELECT COUNT(*) FROM view_full_occurrence_individual_dev ) = 
( SELECT COUNT(*) FROM vfoi_unique_ids_temp ) 
AS counts_match
; 


-- Tidy up
DROP TABLE vfoi_unique_ids_temp;
ALTER TABLE view_full_occurrence_individual_dev DROP COLUMN temp_pk;
-- Time: 3669.266 ms (00:03.669)
ALTER TABLE view_full_occurrence_individual_dev DROP COLUMN keep;
-- Time: 1531.934 ms (00:01.532)

-- Final test. MUST return 0!
SELECT COUNT(*) AS duplicate_agg_traits_id FROM (
SELECT taxonobservation_id, COUNT(*) FROM view_full_occurrence_individual_dev GROUP BY taxonobservation_id HAVING COUNT(*)>1
) a;
