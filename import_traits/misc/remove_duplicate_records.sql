-- ------------------------------------------------------------
-- Remove duplicate records in agg_traits
-- These differ only in the value of fk_gnrs_id, and are the result of 
-- a bug in the GNRS which causes fuzzy match results to be added as 
-- a different record from exact match results. GNRS bug to be fixed 
-- separately.
-- ------------------------------------------------------------

-- Back up agg_traits
CREATE TABLE agg_traits_bak2 AS SELECT * FROM agg_traits;

-- Check for duplicated records
SELECT COUNT(*) AS "duplicated_records"
FROM (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) a;
-- Result: 790 

-- Check that duplicated records are exactly 2 and not more
-- Must return 'f' for method below to work
SELECT EXISTS (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>2
) AS "Has records >2 copies"
;

-- Make table of ids associated with duplicate records, plus the 
-- highest of the two gnrs id values. This later one will be the fuzzy 
-- match 
CREATE TABLE agg_traits_dupes_delete AS
SELECT a.id, MAX(fk_gnrs_id) AS max_gnrs_id
FROM agg_traits a JOIN (
SELECT id, COUNT(*) 
FROM agg_traits
GROUP BY id
HAVING COUNT(*)>1
) b
ON a.id=b.id
GROUP BY a.id
ORDER BY a.id
;

-- Index both tables
CREATE INDEX agg_traits_dupes_delete_id_idx ON agg_traits_dupes_delete (id);
CREATE INDEX agg_traits_dupes_delete_max_gnrs_id_idx ON agg_traits_dupes_delete (max_gnrs_id);
CREATE INDEX agg_traits_id_idx ON agg_traits(id);
CREATE INDEX agg_traits_fk_gnrs_id_idx ON agg_traits(fk_gnrs_id);

-- Extra check that records are otherwise identical
-- MUST equal duplicated_records above
SELECT COUNT(*) AS "duplicated_records_poldivs" 
FROM (
SELECT DISTINCT a.id, country, state_province, county
FROM agg_traits a JOIN agg_traits_dupes_delete b
ON a.id=b.id 
) a
;
-- Result: 790 

-- Count records before
SELECT COUNT(*) FROM agg_traits AS "Total_before";
-- Result: 26889132

-- Delete the records
DELETE FROM agg_traits a
USING agg_traits_dupes_delete b
WHERE a.id=b.id AND a.fk_gnrs_id=b.max_gnrs_id
;

-- Count records after
-- Difference between total_before - total_after MUST equal duplicated_records
SELECT COUNT(*) FROM agg_traits AS "Total_after";
-- Result: 26888342

SELECT 26889132::integer - 26888342::integer AS diff;
-- Result: 790 
-- SUCCESS!

