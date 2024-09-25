-- ---------------------------------------------------------
-- Insert verbatim taxon names
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

INSERT INTO name_submitted (
name_submitted_verbatim,
name_submitted
)
SELECT DISTINCT 
name_submitted,
name_submitted
FROM agg_traits
WHERE name_submitted IS NOT NULL AND name_submitted<>''
;