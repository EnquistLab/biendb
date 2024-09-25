-- 
-- Short term remedy for duplicate records in vfoi, caused by GNRS. 
-- 

-- Solution: delete one of each pair of duplicate records. Specifically, 
-- use MAX function to flag and delete the newer of each
-- duplicate record. This would be the second GNRS records, which is fuzzy
-- matched. However, do not delete from GNRS table, as some of the redundant  
-- records may be shared with agg_traits or ih. Starting from scratch,
-- the slow, conservative, step-by-step way:

-- Back up the table!
DROP TABLE IF EXISTS view_full_occurrence_individual_dev_bak;
CREATE TABLE view_full_occurrence_individual_dev_bak AS
SELECT * FROM view_full_occurrence_individual_dev;

-- Make temp table of unique values of taxonobservation_id associated with  
-- duplicated records
DROP TABLE IF EXISTS vfoi_dup;
CREATE TABLE vfoi_dup AS
SELECT taxonobservation_id FROM (
SELECT taxonobservation_id, count(*)
FROM view_full_occurrence_individual_dev
GROUP BY taxonobservation_id
HAVING count(*)>1
) AS a
ORDER BY taxonobservation_id;
ALTER TABLE vfoi_dup ADD PRIMARY KEY (taxonobservation_id);

-- Create index on taxonobservation_id in vfoi to speed up joins
CREATE INDEX vfoi_taxonobservation_id_idx ON view_full_occurrence_individual_dev (taxonobservation_id);

-- Make table of distinct taxonobservation_id+gnrs.id pairs for the   
-- duplicated records & include field for marking records to delete
DROP TABLE IF EXISTS gnrs_dup;
CREATE TABLE gnrs_dup AS
SELECT distinct a.taxonobservation_id, fk_gnrs_id, 
CAST(0 AS smallint) AS del
FROM view_full_occurrence_individual_dev a JOIN vfoi_dup b
ON a.taxonobservation_id=b.taxonobservation_id
;

-- Mark records to delete
-- Use largest (newest) value of gnrs.id
UPDATE gnrs_dup a
SET del=1
FROM (
SELECT taxonobservation_id, MAX(fk_gnrs_id) AS max_id
FROM gnrs_dup
GROUP BY taxonobservation_id
) AS b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND a.fk_gnrs_id=b.max_id
;

-- Make new table of records to delete
DROP TABLE IF EXISTS gnrs_dup_delete;
CREATE TABLE gnrs_dup_delete AS
SELECT * FROM gnrs_dup
WHERE del=1
;

-- Index the table
CREATE INDEX gnrs_dup_delete_taxonobservation_id_idx ON gnrs_dup_delete (taxonobservation_id);
CREATE INDEX gnrs_dup_delete_fk_gnrs_id_idx ON gnrs_dup_delete (fk_gnrs_id);

-- Create index on fk_gnrs_id in vfoi
CREATE INDEX vfoi_fk_gnrs_id_idx ON view_full_occurrence_individual_dev (fk_gnrs_id);

-- Delete the records
DELETE FROM view_full_occurrence_individual_dev a
USING gnrs_dup_delete b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND a.fk_gnrs_id=b.fk_gnrs_id
;

-- Count number of records that should have been deleted
SELECT count(*)::integer AS expected 
FROM gnrs_dup_delete
;

-- Compare records before and after
-- MUST return 't'
SELECT before - after = expected FROM 
(
SELECT count(*)::integer AS before 
FROM view_full_occurrence_individual_dev_bak
) a,
(
SELECT count(*)::integer AS after 
FROM view_full_occurrence_individual_dev
) b,
(
SELECT count(*)::integer AS expected 
FROM gnrs_dup_delete
) c
; 

-- All good? Tidy up:
DROP TABLE gnrs_dup_delete;
DROP TABLE view_full_occurrence_individual_dev_bak;
DROP INDEX vfoi_taxonobservation_id_idx;
DROP INDEX vfoi_fk_gnrs_id_idx;


-- Recommend keep gnrs_dup, just in case
