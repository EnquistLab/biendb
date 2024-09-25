-- 
-- Diagnose and fix duplicate records in agg_traits
-- Duplicates found after running updates through geovalidation
--

-- Check for duplicated records
SELECT COUNT(*) AS "duplicated_ids"
FROM (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) a;
-- Result: 675 

-- Check that duplicated records are exactly 2 and not more
-- Must return 'f' for method below to work
SELECT EXISTS (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>2
) AS "Has records >2 copies"
;

-- Count records with duplicated ids
select count(*) from (
select a.* from agg_traits a join (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) b on a.id=b.id
) c
;
-- RESULTS: 1350

-- total DISTINCT records with duplicate ids
select count(*) from (
select distinct a.* from agg_traits a join (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) b on a.id=b.id
) c
;
-- RESULTS: 675

-- Conclusion: duplicate records are identical

-- The fix:

DROP TABLE IF EXISTS temp;
CREATE TABLE temp AS
SELECT a.* FROM agg_traits a JOIN (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) b 
ON a.id=b.id
;
DROP TABLE IF EXISTS agg_traits_dupe_records;
CREATE TABLE agg_traits_dupe_records AS
SELECT DISTINCT * FROM temp;
DROP TABLE temp;

-- backup agg_traits
CREATE TABLE agg_traits_bak_20022108 AS SELECT * FROM agg_traits;

ALTER TABLE agg_traits_dupe_records ADD PRIMARY KEY (id);
CREATE INDEX agg_traits_id_idx ON agg_traits(id);

DELETE FROM agg_traits a
USING agg_traits_dupe_records b
WHERE a.id=b.id
;

INSERT INTO agg_traits
SELECT * FROM agg_traits_dupe_records
;

-- Check the result
SELECT EXISTS (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) AS "has_duplicated_ids"
;


DROP TABLE agg_traits_dupe_records;

DROP INDEX agg_traits_id_idx;