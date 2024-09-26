-- ---------------------------------------------------------------
-- Remove duplicate records from centroid and centroid tables
-- ---------------------------------------------------------------

-- 
-- centroid
-- 

CREATE TABLE centroid_dupe_ids AS 
SELECT tbl, tbl_id, COUNT(*) AS tot
FROM centroid
GROUP BY tbl, tbl_id
HAVING COUNT(*)>1
;
CREATE INDEX ON centroid_dupe_ids (tbl);
CREATE INDEX ON centroid_dupe_ids (tbl_id,tbl);


-- Check for duplicated ids
SELECT COUNT(*) AS "duplicated_ids"
FROM centroid_dupe_ids
;
-- RESULT: 8241582

-- Check that for records with >2 copies
-- Must return 'f' for method below to work
SELECT EXISTS (
SELECT * FROM centroid_dupe_ids
WHERE tot>2
) AS "Has records with >2 copies"
;
-- RESULT: t

-- Count records with duplicated ids
SELECT SUM(tot) AS "duplicated_records" FROM centroid_dupe_ids;
-- RESULTS: 82629040 (!!!)

-- Make table of full duplicated records
CREATE TABLE centroid_dupe_records AS
SELECT a.* 
FROM centroid a
JOIN centroid_dupe_ids b
ON a.tbl=b.tbl
AND a.tbl_id=b.tbl_id
;
-- RESULT: Inserted 82629040 records

ALTER TABLE centroid_dupe_records RENAME TO temp;
CREATE TABLE centroid_dupe_records AS
SELECT DISTINCT * FROM temp;
DROP TABLE temp;
ALTER TABLE centroid_dupe_records ADD PRIMARY KEY (tbl_id,tbl);
CREATE INDEX ON centroid_dupe_records (tbl);

-- Since PK failed, need to index instead
CREATE INDEX ON centroid_dupe_records (tbl_id);

-- backup copy
CREATE TABLE centroid_dupe_records_bak AS 
SELECT * FROM centroid_dupe_records;

ALTER TABLE centroid_dupe_records DROP COLUMN centroid_id;
ALTER TABLE centroid_dupe_records RENAME TO temp;
CREATE TABLE centroid_dupe_records AS
SELECT DISTINCT * FROM temp;
DROP TABLE temp;


ALTER TABLE centroid_dupe_records ADD PRIMARY KEY (tbl_id,tbl);
CREATE INDEX ON centroid_dupe_records (tbl);





-- Count distinct records
-- If duplicated records are identical
-- will equal "duplicated_ids" above
SELECT COUNT(*) FROM centroid_dupe_records
;
-- RESULT: xxx
-- CONCLUSION: Yes, records are completely duplicated

-- If duplicated records are identical then this will fix the problem
DELETE FROM centroid a
USING centroid_dupe_records b
WHERE a.tbl=b.tbl
AND a.tbl_id=b.tbl_id
;

INSERT INTO centroid
SELECT * FROM centroid_dupe_records
;

-- Check the results
-- Should return 'f'
SELECT EXISTS (
SELECT tbl_id, COUNT(*) AS tot
FROM centroid
WHERE tbl='traits'
GROUP BY tbl_id
HAVING COUNT(*)>1
LIMIT 1
) AS "has_duplicated_ids_traits"
;
SELECT EXISTS (
SELECT tbl_id, COUNT(*) AS tot
FROM centroid
WHERE tbl='vfoi'
GROUP BY tbl_id
HAVING COUNT(*)>1
LIMIT 1
) AS "has_duplicated_ids_vfoi"
;

DROP TABLE centroid_dupe_records;
DROP TABLE centroid_dupe_ids;
