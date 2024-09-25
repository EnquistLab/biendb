-- ---------------------------------------------------------
-- Load unique values from nsr_submitted_raw into 
-- nsr_submitted & add all indexes needed
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- Populate FK fk_taxon_poldiv & index it
-- 

UPDATE nsr_submitted_raw
SET fk_taxon_poldiv=CONCAT_WS('@',
COALESCE(family,''),
COALESCE(genus,''),
COALESCE(species,''),
COALESCE(country,''),
COALESCE(state_province,''),
COALESCE(county_parish,'')
)
;

-- Index the FK
DROP INDEX IF EXISTS nsr_submitted_raw_fk_taxon_poldiv_idx;
CREATE INDEX nsr_submitted_raw_fk_taxon_poldiv_idx ON nsr_submitted_raw (fk_taxon_poldiv);

-- Index column needed for joining results back to original tables
-- Separate index on tbl_id *may* speed up joins back to original table
-- Not sure though; need to do some benchmarking
DROP INDEX IF EXISTS nsr_submitted_raw_tbl_name_tbl_id_idx;
CREATE UNIQUE INDEX nsr_submitted_raw_tbl_name_tbl_id_idx ON nsr_submitted_raw (tbl_name,tbl_id);
DROP INDEX IF EXISTS nsr_submitted_raw_tbl_id_idx;
CREATE INDEX nsr_submitted_raw_tbl_id_idx ON nsr_submitted_raw (tbl_id);
--
-- Insert unique values into nsr_submitted & index the text
-- candidate PK 
-- 

INSERT INTO nsr_submitted (
taxon_poldiv,
family,
genus,
species,
country,
state_province,
county_parish
) 
SELECT DISTINCT
fk_taxon_poldiv,
family,
genus,
species,
country,
state_province,
county_parish
FROM nsr_submitted_raw
;

-- Index the FK
DROP INDEX IF EXISTS nsr_submitted_taxon_poldiv_idx;
CREATE INDEX nsr_submitted_taxon_poldiv_idx ON nsr_submitted (taxon_poldiv);