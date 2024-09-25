-- ---------------------------------------------------------
-- Adds additional indexes to table tnrs_scrubbed and fixes
-- misc bugs in TNRS output
-- ---------------------------------------------------------

set search_path to :sch;

DROP INDEX IF EXISTS tnrs_scrubbed_name_matched_idx;
CREATE INDEX tnrs_scrubbed_name_matched_idx ON tnrs_scrubbed (name_matched);

-- Add PK & column for FK to table bien_taxonomy
-- Not addition of column "selected": present in online TNRS results 
-- but absent from TNRSbatch results
ALTER TABLE tnrs_scrubbed
ADD COLUMN name_submitted_rank text,
ADD COLUMN bien_taxonomy_id bigint,
ADD COLUMN tnrs_scrubbed_id bigserial primary key,
ADD COLUMN selected text
;

-- Remove no matches message
UPDATE tnrs_scrubbed
SET name_matched=NULL
WHERE name_matched='No suitable matches found.'
;

-- Correct non-standard rank identifiers from USDA Plants (TNRS bug)
UPDATE tnrs_scrubbed
SET name_matched=REPLACE(name_matched,'ssp.','subsp.'),
accepted_name=REPLACE(accepted_name,'ssp.','subsp.')
WHERE name_matched LIKE '%ssp.%'
;

-- Correct weird double '..' after 'cv' in some USDA Plants names
UPDATE tnrs_scrubbed
SET accepted_name=REPLACE(accepted_name,'..','.')
WHERE accepted_name LIKE '%..%'
;

-- Fix weird glitch where genus sometimes place in accepted_name_species
DROP INDEX IF EXISTS tnrs_scrubbed_accepted_name_rank_idx;
CREATE INDEX tnrs_scrubbed_accepted_name_rank_idx ON tnrs_scrubbed (accepted_name_rank);

DROP INDEX IF EXISTS tnrs_scrubbed_accepted_name_species_idx;
CREATE INDEX tnrs_scrubbed_accepted_name_species_idx ON tnrs_scrubbed (accepted_name_species);

UPDATE tnrs_scrubbed
SET accepted_name_species=NULL
WHERE accepted_name_rank IN ('genus','family','section','subsection','nothospecies','subfamily','subgenus')
AND accepted_name_species IS NOT NULL
;

-- Drop all indexes except PK
DROP INDEX IF EXISTS tnrs_scrubbed_name_id_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_name_submitted_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_name_matched_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_selected_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_accepted_name_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_warnings_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS tnrs_scrubbed_specific_epithet_matched_idx;

-- scrubbed (=accepted) name
UPDATE tnrs_scrubbed
SET accepted_name=NULL
WHERE TRIM(accepted_name)=''
;
