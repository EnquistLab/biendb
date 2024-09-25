-- ---------------------------------------------------------
-- Populates political divisions foreign key "poldivs_full"
-- in preparation for scrubbing with GNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Populate the FK
-- inserts empty string for county
UPDATE ih
SET poldiv_full=CONCAT(
trim(country_verbatim), '@',
trim(state_province_verbatim),
'@'
)
;

-- Index the FK
DROP INDEX IF EXISTS ih_poldiv_full_idx;
CREATE INDEX ih_poldiv_full_idx ON ih (poldiv_full);