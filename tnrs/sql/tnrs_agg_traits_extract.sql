-- ---------------------------------------------------------
-- Insert verbatim taxon names
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Fill in any missing values of name submitted
-- Not sure why this is happening, but mopping up here
UPDATE agg_traits
SET 
name_submitted=TRIM(CONCAT_WS(' ',verbatim_family, verbatim_scientific_name))
WHERE name_submitted IS NULL
AND 
( verbatim_family IS NOT NULL OR verbatim_scientific_name IS NOT NULL )
;

INSERT INTO tnrs_submitted (
name_submitted_verbatim,
name_submitted
)
SELECT DISTINCT 
name_submitted,
name_submitted
FROM agg_traits
WHERE name_submitted IS NOT NULL AND name_submitted<>''
;