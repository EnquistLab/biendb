-- 
-- Diagnose and fix duplicate records in view_full_occurrence_individual_dev
-- Duplicates found after running updates through geovalidation
--

CREATE INDEX vfoi_taxonobservation_id_idx ON view_full_occurrence_individual_dev (taxonobservation_id);


-- Make table of duplicated ids; this is faster
CREATE TABLE vfoi_dupe_ids AS 
SELECT taxonobservation_id, COUNT(*) AS tot
FROM view_full_occurrence_individual_dev
GROUP BY taxonobservation_id
HAVING COUNT(*)>1
;
CREATE INDEX ON vfoi_dupe_ids (taxonobservation_id);
CREATE INDEX ON vfoi_dupe_ids (tot);

-- Check for duplicated ids
SELECT COUNT(*) AS "duplicated_ids"
FROM vfoi_dupe_ids
;
-- Result: 214467 

-- Check that for records with >2 copies
-- Must return 'f' for method below to work
SELECT EXISTS (
SELECT * FROM vfoi_dupe_ids
WHERE tot>2
) AS "Has records with >2 copies"
;
-- RESULT: f

-- Count records with duplicated ids
SELECT SUM(tot) AS "duplicated_records" FROM vfoi_dupe_ids;
-- RESULTS: 428934

-- Make table of full duplicated records
CREATE TABLE vfoi_dupe_records AS
SELECT a.* 
FROM view_full_occurrence_individual_dev a
JOIN vfoi_dupe_ids b
ON a.taxonobservation_id=b.taxonobservation_id
;

-- Check if duplicated records are identical
-- If so, will equal "duplicated_ids" above
SELECT COUNT(*) FROM (
SELECT DISTINCT *
FROM vfoi_dupe_records
) AS a
;
-- RESULT: 214467
-- CONCLUSION: Yes, records are completely duplicated

-- The fix:

ALTER TABLE vfoi_dupe_records RENAME TO temp;
DROP TABLE IF EXISTS vfoi_dupe_records;
CREATE TABLE vfoi_dupe_records AS
SELECT DISTINCT * FROM temp;
DROP TABLE temp;
ALTER TABLE vfoi_dupe_records ADD PRIMARY KEY (taxonobservation_id);

-- backup view_full_occurrence_individual_dev
CREATE TABLE view_full_occurrence_individual_dev_bak_20022108 AS SELECT * FROM view_full_occurrence_individual_dev;

DELETE FROM view_full_occurrence_individual_dev a
USING vfoi_dupe_records b
WHERE a.taxonobservation_id=b.taxonobservation_id
;

-- drop index to speed up the remaining steps
DROP INDEX vfoi_taxonobservation_id_idx;

INSERT INTO view_full_occurrence_individual_dev
SELECT * FROM vfoi_dupe_records
;

-- Check the result
SELECT EXISTS (
SELECT taxonobservation_id, COUNT(*) 
FROM view_full_occurrence_individual_dev
GROUP BY taxonobservation_id
HAVING COUNT(*)>1
LIMIT 1
) AS "has_duplicated_ids"
;

DROP TABLE vfoi_dupe_records;
DROP TABLE vfoi_dupe_ids;
