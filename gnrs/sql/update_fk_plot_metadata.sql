-- ---------------------------------------------------------
-- Populates political divisions foreign key "poldivs_full"
-- in preparation for scrubbing with GNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- Fix mystery error with plot_metadata; investigate in detail later
--

UPDATE plot_metadata
SET country_verbatim=country,
state_province_verbatim=state_province,
county_verbatim=county
WHERE (TRIM(country_verbatim)='' OR country_verbatim IS NULL)
AND country IS NOT NULL
;
UPDATE plot_metadata
SET country=NULL,
state_province=NULL,
county=NULL
;

--
-- Convert NULL verbatim field to empty string
-- 

-- Create is-null partial indexes
DROP INDEX IF EXISTS plot_metadata_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS plot_metadata_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS plot_metadata_county_verbatim_is_null_idx;

CREATE INDEX plot_metadata_country_verbatim_is_null_idx ON plot_metadata (country_verbatim) WHERE country_verbatim IS NULL;
CREATE INDEX plot_metadata_state_province_verbatim_is_null_idx ON plot_metadata (state_province_verbatim) WHERE state_province_verbatim IS NULL;
CREATE INDEX plot_metadata_county_verbatim_is_null_idx ON plot_metadata (county_verbatim) WHERE county_verbatim IS NULL;

-- Set NULLs to ''
UPDATE plot_metadata
SET 
country_verbatim=CASE WHEN country_verbatim IS NULL THEN '' ELSE country_verbatim END,
state_province_verbatim=CASE WHEN state_province_verbatim IS NULL THEN '' ELSE state_province_verbatim END,
county_verbatim=CASE WHEN county_verbatim IS NULL THEN '' ELSE county_verbatim END
;

-- Drop the partial indexes
DROP INDEX IF EXISTS plot_metadata_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS plot_metadata_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS plot_metadatai_country_verbatim_is_null_idx;

--
-- Populate the FK
--

ALTER TABLE plot_metadata DROP COLUMN IF EXISTS poldiv_full;
ALTER TABLE plot_metadata
ADD COLUMN poldiv_full text DEFAULT NULL
;

UPDATE plot_metadata
SET poldiv_full=CONCAT_WS('@',
trim(country_verbatim), 
trim(state_province_verbatim), 
trim(county_verbatim) 
)
;

-- Index the FK
DROP INDEX IF EXISTS plot_metadata_poldiv_full_idx;
CREATE INDEX plot_metadata_poldiv_full_idx ON plot_metadata (poldiv_full);