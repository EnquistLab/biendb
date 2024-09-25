-- ---------------------------------------------------------
-- Extract unique verbatim taxon names for submission to TNRS
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS name_submitted_temp;
CREATE TABLE name_submitted_temp ( LIKE name_submitted including defaults including constraints);

INSERT INTO name_submitted_temp (
name_submitted_verbatim,
name_submitted 
)
SELECT DISTINCT 
name_submitted_verbatim,
name_submitted
FROM name_submitted;

DROP TABLE name_submitted CASCADE;

ALTER TABLE name_submitted_temp RENAME TO name_submitted;