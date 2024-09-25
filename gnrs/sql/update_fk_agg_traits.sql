-- ---------------------------------------------------------
-- Populates political divisions foreign key "poldivs_full"
-- in preparation for scrubbing with GNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Create is-null partial indexes
DROP INDEX IF EXISTS agg_traits_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_county_verbatim_is_null_idx;

CREATE INDEX agg_traits_country_verbatim_is_null_idx ON agg_traits (country_verbatim) WHERE country_verbatim IS NULL;
CREATE INDEX agg_traits_state_province_verbatim_is_null_idx ON agg_traits (state_province_verbatim) WHERE state_province_verbatim IS NULL;
CREATE INDEX agg_traits_county_verbatim_is_null_idx ON agg_traits (county_verbatim) WHERE county_verbatim IS NULL;

-- Set NULLs to ''
UPDATE agg_traits
SET 
country_verbatim=CASE WHEN country_verbatim IS NULL THEN '' ELSE country_verbatim END,
state_province_verbatim=CASE WHEN state_province_verbatim IS NULL THEN '' ELSE state_province_verbatim END,
county_verbatim=CASE WHEN county_verbatim IS NULL THEN '' ELSE county_verbatim END
;

-- Drop the partial indexes
DROP INDEX IF EXISTS agg_traits_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_country_verbatim_is_null_idx;

-- Populate the FK
UPDATE agg_traits
SET poldiv_full=CONCAT_WS('@',
trim(country_verbatim), 
trim(state_province_verbatim), 
trim(county_verbatim) 
)
;

-- Index FK
DROP INDEX IF EXISTS agg_traits_poldiv_full_idx;
CREATE INDEX agg_traits_poldiv_full_idx ON agg_traits (poldiv_full);