-- ---------------------------------------------------------
-- Insert verbatim taxon names
-- ---------------------------------------------------------

SET search_path TO :sch;

INSERT INTO tnrs_submitted (
name_submitted_verbatim,
name_submitted
)
SELECT DISTINCT 
name_submitted,
name_submitted
FROM view_full_occurrence_individual_dev
WHERE name_submitted IS NOT NULL AND name_submitted<>''
;