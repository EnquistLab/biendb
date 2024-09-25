-- ---------------------------------------------------------
-- Extract data to be sent to NSR from table vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- nsr_submitted_raw
-- 

-- 1:1 extract, just the columns needed for NSR, no indexes
INSERT INTO nsr_submitted_raw 
SELECT
CAST('view_full_occurrence_individual' AS text) AS tbl_name,
taxonobservation_id AS tbl_id,
scrubbed_species_binomial AS taxon,
country AS country,
state_province AS state_province,
county AS county_parish
FROM view_full_occurrence_individual_dev
WHERE country IS NOT NULL
AND scrubbed_species_binomial IS NOT NULL
;

