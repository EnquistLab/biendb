-- ---------------------------------------------------------
-- Adds additional columns and indexes to table taxon_verbatim_parsed
-- ---------------------------------------------------------

set search_path to :dev_schema;

CREATE INDEX ON taxon_verbatim_scrubbed (name_matched);

-- Remove no matches message
UPDATE taxon_verbatim_scrubbed
SET name_matched=NULL
WHERE name_matched='No suitable matches found.'
;

-- Correct non-standard rank identifiers from USDA Plants (TNRS bug)
UPDATE taxon_verbatim_scrubbed
SET name_matched=REPLACE(name_matched,'ssp.','subsp.'),
accepted_name=REPLACE(accepted_name,'ssp.','subsp.')
WHERE name_matched LIKE '%ssp.%'
;

-- Correct weird double '..' after 'cv' in some USDA Plants names
UPDATE taxon_verbatim_scrubbed
SET accepted_name=REPLACE(accepted_name,'..','.')
WHERE accepted_name LIKE '%..%'
;

CREATE INDEX ON taxon_verbatim_scrubbed (user_id);
CREATE INDEX ON taxon_verbatim_scrubbed (selected);
CREATE INDEX ON taxon_verbatim_scrubbed (accepted_name);
CREATE INDEX ON taxon_verbatim_scrubbed (warnings);