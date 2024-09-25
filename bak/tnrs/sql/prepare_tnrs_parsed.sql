-- ---------------------------------------------------------
-- Adds additional columns and indexes to table tnrs_parsed
-- ---------------------------------------------------------

set search_path to :sch;

-- Add rank column and FK to table bien_taxonomy
ALTER TABLE tnrs_parsed
ADD COLUMN taxon_parsed_rank text,
ADD COLUMN bien_taxonomy_id bigint,
ADD COLUMN tnrs_parsed_id bigserial primary key
;

-- Add indexes needed for next steps
CREATE INDEX ON tnrs_parsed (family);
CREATE INDEX ON tnrs_parsed (genus);
CREATE INDEX ON tnrs_parsed (specific_epithet);
CREATE INDEX ON tnrs_parsed (infraspecific_epithet);

-- Populate parsed_taxon_rank
UPDATE tnrs_parsed
SET taxon_parsed_rank=
CASE
WHEN genus IS NULL THEN 'family'
WHEN specific_epithet IS NULL THEN 'genus'
WHEN infraspecific_epithet IS NULL THEN 'species'
WHEN infraspecific_epithet IS NOT NULL THEN 'subspecies'
ELSE 'unknown'
END
;

CREATE INDEX ON tnrs_parsed (taxon_parsed_rank);
CREATE INDEX ON tnrs_parsed (taxon_name);
CREATE INDEX ON tnrs_parsed (infraspecific_rank);

-- Assume 'var.' where infraspecific rank not supplied
UPDATE tnrs_parsed
SET taxon_name=REPLACE(TRIM(taxon_name),'  ',' var. ')
WHERE taxon_parsed_rank='subspecies'
AND infraspecific_rank IS NULL
; 

CREATE INDEX tnrs_parsed_name_submitted_idx ON tnrs_parsed (name_submitted);