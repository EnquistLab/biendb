-- ---------------------------------------------------------
-- Extract unique verbatim taxon names for submission to TNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS tnrs_submitted_temp;
CREATE TABLE tnrs_submitted_temp ( LIKE tnrs_submitted including defaults including constraints);

INSERT INTO tnrs_submitted_temp (
name_submitted,
name_submitted_verbatim
)
SELECT DISTINCT 
name_submitted,
name_submitted_verbatim
FROM tnrs_submitted
WHERE name_submitted IS NOT NULL AND TRIM(name_submitted)<>''
;

DROP TABLE tnrs_submitted CASCADE;

ALTER TABLE tnrs_submitted_temp RENAME TO tnrs_submitted;

-- Add auto-increment ID column
ALTER TABLE tnrs_submitted 
ADD COLUMN name_id BIGSERIAL PRIMARY KEY
;

-- Index everything
DROP INDEX IF EXISTS tnrs_submitted_name_submitted_idx;
DROP INDEX IF EXISTS tnrs_submitted_name_submitted_verbatim_idx;

CREATE INDEX tnrs_submitted_name_submitted_idx ON tnrs_submitted (name_submitted);
CREATE INDEX tnrs_submitted_name_submitted_verbatim_idx ON tnrs_submitted (name_submitted_verbatim);
