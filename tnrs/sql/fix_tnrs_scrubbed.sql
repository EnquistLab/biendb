-- ---------------------------------------------------------
-- Fixing issues specific to output of TNRSbatch
-- ---------------------------------------------------------

set search_path to :sch;

-- Remove single quotes around name_submitted
UPDATE tnrs_scrubbed
SET name_submitted = TRIM(RIGHT( LEFT( name_submitted, LENGTH( name_submitted ) - 1 ), LENGTH( LEFT( name_submitted, LENGTH( name_submitted ) - 1 ) ) - 1 ))
WHERE name_submitted LIKE '''%' AND name_submitted LIKE '%'''
;

-- Remove leading single quote from unmatched_terms
UPDATE tnrs_scrubbed
SET unmatched_terms = TRIM(RIGHT( unmatched_terms, LENGTH( unmatched_terms ) - 1 ))
WHERE unmatched_terms LIKE '''%'
;

DROP INDEX IF EXISTS tnrs_scrubbed_name_submitted_idx;
CREATE INDEX tnrs_scrubbed_name_submitted_idx ON tnrs_scrubbed (name_submitted);

-- Populate missing name ids
UPDATE tnrs_scrubbed a
SET name_id=b.name_id
FROM tnrs_submitted b
WHERE a.name_submitted=b.name_submitted
AND a.name_id is NULL
;

DROP INDEX IF EXISTS tnrs_scrubbed_name_submitted_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_name_id_idx;
CREATE INDEX tnrs_scrubbed_name_id_idx ON tnrs_scrubbed (name_id);

-- Restore original name
ALTER TABLE tnrs_scrubbed
ADD COLUMN name_submitted_verbatim TEXT
;
UPDATE tnrs_scrubbed a
SET 
name_submitted_verbatim=b.name_submitted_verbatim,
name_submitted=b.name_submitted
FROM tnrs_submitted b
WHERE a.name_id=b.name_id
;
