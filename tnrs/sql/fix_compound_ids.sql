-- ---------------------------------------------------------
-- Unpack records with compound ids into separate records
-- ---------------------------------------------------------

set search_path to :sch;

-- Extract just the compound id rows
DROP TABLE IF EXISTS tnrs_scrubbed_cmpd;
CREATE TABLE tnrs_scrubbed_cmpd AS
SELECT *
FROM tnrs_scrubbed
WHERE name_id LIKE '%,%'
;

-- Unpack records using lateral join
DROP TABLE IF EXISTS tnrs_scrubbed_uniq;
CREATE TABLE tnrs_scrubbed_uniq AS
SELECT s.token AS name_id_uniq, t.*
FROM tnrs_scrubbed_cmpd t, unnest(string_to_array(t.name_id, ',')) s(token)
;
ALTER TABLE tnrs_scrubbed_uniq 
DROP COLUMN name_id
;
ALTER TABLE tnrs_scrubbed_uniq 
RENAME name_id_uniq TO name_id
;

-- Replace compound rows in original table with unique rows
-- and delete the temp tables
DELETE FROM tnrs_scrubbed
WHERE name_id LIKE '%,%'
;
INSERT INTO tnrs_scrubbed
SELECT * FROM tnrs_scrubbed_uniq
;

DROP TABLE tnrs_scrubbed_uniq;
DROP TABLE tnrs_scrubbed_cmpd;

-- Now change ID field back to integer
ALTER TABLE tnrs_scrubbed
ALTER COLUMN name_id TYPE bigint USING name_id::bigint
; 
