-- ---------------------------------------------------------
-- Adds additional columns and indexes to table taxon_verbatim_parsed
-- ---------------------------------------------------------

set search_path to :dev_schema;

-- Populate rank of parsed name, for comparison with scrubbed name
ALTER TABLE taxon_verbatim_parsed
ADD COLUMN taxon_parsed_rank TEXT;

-- Add indexes needed for next steps
CREATE INDEX ON taxon_verbatim_parsed (family);
CREATE INDEX ON taxon_verbatim_parsed (genus);
CREATE INDEX ON taxon_verbatim_parsed (specific_epithet);
CREATE INDEX ON taxon_verbatim_parsed (infraspecific_epithet);

-- Populate parsed_taxon_rank
UPDATE taxon_verbatim_parsed
SET taxon_parsed_rank=
CASE
WHEN genus IS NULL THEN 'family'
WHEN specific_epithet IS NULL THEN 'genus'
WHEN infraspecific_epithet IS NULL THEN 'species'
WHEN infraspecific_epithet IS NOT NULL THEN 'subspecies'
ELSE 'unknown'
END
;

CREATE INDEX ON taxon_verbatim_parsed (taxon_parsed_rank);
CREATE INDEX ON taxon_verbatim_parsed (taxon_name);
CREATE INDEX ON taxon_verbatim_parsed (infraspecific_rank);

-- Assume 'var.' where infraspecific rank not supplied
UPDATE taxon_verbatim_parsed
SET taxon_name=REPLACE(TRIM(taxon_name),'  ',' var. ')
WHERE taxon_parsed_rank='subspecies'
AND infraspecific_rank IS NULL
; 

CREATE INDEX taxon_verbatim_parsed_user_id_idx ON taxon_verbatim_parsed (user_id);
