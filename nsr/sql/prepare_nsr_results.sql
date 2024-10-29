-- -------------------------------------------------------------
-- Prepare nsr results table
-- -------------------------------------------------------------

SET search_path TO :sch;

--
-- Make unique copy of nsr results
--

-- Backup original nsr table by renaming, if it exists
ALTER TABLE IF EXISTS nsr RENAME TO nsr_orig;
DROP TABLE IF EXISTS nsr;

-- Create new table by copying schema of original and reset integer pkey
CREATE TABLE nsr (LIKE nsr_orig);
CREATE SEQUENCE nsr_id_seq;
ALTER TABLE nsr ALTER COLUMN id SET DEFAULT nextval('nsr_id_seq'); 
ALTER SEQUENCE nsr_id_seq OWNED BY nsr.id;

-- Insert new results
INSERT INTO nsr (
family,
genus,
species,
country,
state_province,
county_parish,
poldiv_full,
poldiv_type,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
is_cultivated_taxon
)
SELECT DISTINCT
family,
genus,
species,
country,
state_province,
county_parish,
poldiv_full,
poldiv_type,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
is_cultivated_taxon
FROM nsr_orig
;
DROP TABLE nsr_orig;

--
-- Add text FK and index it
--
ALTER TABLE nsr
ADD COLUMN taxon_poldiv TEXT
;

UPDATE nsr
SET taxon_poldiv=CONCAT_WS('@',
COALESCE(species,''),
COALESCE(country,''),
COALESCE(state_province,''),
COALESCE(county_parish,'')
)
;

-- Index the FK
DROP INDEX IF EXISTS nsr_taxon_poldiv_idx;
CREATE UNIQUE INDEX nsr_taxon_poldiv_idx ON nsr (taxon_poldiv);

-- Drop the sequence, no longer needed
ALTER TABLE nsr ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE nsr_id_seq;
