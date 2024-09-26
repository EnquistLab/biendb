-- ---------------------------------------------------------------
-- Remove duplicate records from geovalidation table
-- ---------------------------------------------------------------

-- 
-- geovalidation
-- 

CREATE TABLE geov_dupe_ids AS 
SELECT tbl, id, COUNT(*) AS tot
FROM geovalidation
GROUP BY tbl, id
HAVING COUNT(*)>1
;
CREATE INDEX ON geov_dupe_ids (tbl);
CREATE INDEX ON geov_dupe_ids (id,tbl);


-- Check for duplicated ids
SELECT COUNT(*) AS "duplicated_ids"
FROM geov_dupe_ids
;
-- RESULT: 215142

-- Check that for records with >2 copies
-- Must return 'f' for method below to work
SELECT EXISTS (
SELECT * FROM geov_dupe_ids
WHERE tot>2
) AS "Has records with >2 copies"
;
-- RESULT: f

-- Count records with duplicated ids
SELECT SUM(tot) AS "duplicated_records" FROM geov_dupe_ids;
-- RESULTS: 430284

-- Make table of full duplicated records
CREATE TABLE geov_dupe_records AS
SELECT a.* 
FROM geovalidation a
JOIN geov_dupe_ids b
ON a.tbl=b.tbl
AND a.id=b.id
;

-- Check if duplicated records are identical
-- If so, will equal "duplicated_ids" above
SELECT COUNT(*) FROM (
SELECT DISTINCT *
FROM geov_dupe_records
) AS a
;
-- RESULT: 215142
-- CONCLUSION: Yes, records are completely duplicated

ALTER TABLE geov_dupe_records RENAME TO temp;
CREATE TABLE geov_dupe_records AS
SELECT DISTINCT * FROM temp;
DROP TABLE temp;
ALTER TABLE geov_dupe_records ADD PRIMARY KEY (id,tbl);
CREATE INDEX ON geov_dupe_records (tbl);

DELETE FROM geovalidation a
USING geov_dupe_records b
WHERE a.tbl=b.tbl
AND a.id=b.id
;

INSERT INTO geovalidation
SELECT * FROM geov_dupe_records
;

-- Check the results
-- Should be return 'f'
SELECT EXISTS (
SELECT id, COUNT(*) AS tot
FROM geovalidation
WHERE tbl='traits'
GROUP BY id
HAVING COUNT(*)>1
LIMIT 1
) AS "has_duplicated_ids_traits"
;
SELECT EXISTS (
SELECT id, COUNT(*) AS tot
FROM geovalidation
WHERE tbl='vfoi'
GROUP BY id
HAVING COUNT(*)>1
LIMIT 1
) AS "has_duplicated_ids_vfoi"
;

DROP TABLE vfoi_dupe_records;
DROP TABLE geov_dupe_ids;

