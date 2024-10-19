-- ---------------------------------------------------------
-- Extract data to be sent to NSR from table vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- nsr_submitted_raw
-- 

-- 1:1 extract, just the columns needed for NSR, no indexes
INSERT INTO nsr_submitted_raw (
tbl_name,
tbl_id,
taxon,
country,
state_province,
county_parish
)
SELECT
CAST('view_full_occurrence_individual' AS text),
taxonobservation_id,
scrubbed_species_binomial,
country,
state_province,
county
FROM :"vfoi"
WHERE country IS NOT NULL
AND scrubbed_species_binomial IS NOT NULL
:sql_limit
;

