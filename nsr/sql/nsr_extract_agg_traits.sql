-- ---------------------------------------------------------
-- Extract data to be sent to NSR from table agg_traits
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- nsr_submitted_raw
-- 

-- 1:1 extract, just the columns needed for NSR, no indexes
INSERT INTO nsr_submitted_raw 
SELECT
CAST('agg_traits' AS text) AS tbl_name,
id AS tbl_id,
scrubbed_species_binomial AS taxon,
country AS country,
state_province AS state_province,
county AS county_parish
FROM agg_traits
WHERE country IS NOT NULL
AND scrubbed_species_binomial IS NOT NULL
;

