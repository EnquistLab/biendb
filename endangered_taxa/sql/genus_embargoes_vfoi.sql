-- ---------------------------------------------------------
-- Apply genus-level taxon embargoes
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS vfoi_scrubbed_genus_idx;
CREATE INDEX vfoi_scrubbed_genus_idx ON view_full_occurrence_individual_dev (scrubbed_genus);

-- global genus-level embargoes
UPDATE view_full_occurrence_individual_dev a
SET 
cites=b.cites_status,
iucn=b.iucn_status,
is_embargoed_observation=1
FROM endangered_taxa b
WHERE b.taxon_rank='genus'
AND (b.cites_status IS NOT NULL OR b.iucn_status IS NOT NULL)
AND a.scrubbed_genus=b.taxon_scrubbed_canonical
;

-- US genus-level embargoes

DROP INDEX IF EXISTS vfoi_country_us_idx;
CREATE INDEX vfoi_country_us_idx ON view_full_occurrence_individual_dev (country)
WHERE (country='United States' OR country='USA' 
OR country='U.S.A.' OR country='U.S.' OR country='US');

UPDATE view_full_occurrence_individual_dev a
SET 
usda_federal=b.usda_status_fed,
is_embargoed_observation=1
FROM endangered_taxa b
WHERE b.taxon_rank='genus'
AND b.usda_status_fed IS NOT NULL
AND (country='United States' OR country='USA' 
OR country='U.S.A.' OR country='U.S.' OR country='US')
AND a.scrubbed_genus=b.taxon_scrubbed_canonical
;

-- US state-specific genus-level embargoes
DROP INDEX IF EXISTS vfoi_us_states_idx;
CREATE INDEX vfoi_us_states_idx ON view_full_occurrence_individual_dev (state_province)
WHERE (country='United States' OR country='USA' 
OR country='U.S.A.' OR country='U.S.' OR country='US');

UPDATE view_full_occurrence_individual_dev a
SET 
usda_state=b.usda_status_state,
is_embargoed_observation=1
FROM endangered_taxa_by_state b
WHERE b.taxon_rank='genus'
AND (country='United States' OR country='USA' 
OR country='U.S.A.' OR country='U.S.' OR country='US')
AND a.scrubbed_genus=b.taxon_scrubbed_canonical
AND (a.state_province=b.state_abbrev OR a.state_province=b.state_abbrev_alt 
OR a.state_province=b.state_name)
;

-- Drop indexes
DROP INDEX vfoi_scrubbed_genus_idx;
DROP INDEX vfoi_country_us_idx;
DROP INDEX vfoi_us_states_idx;
