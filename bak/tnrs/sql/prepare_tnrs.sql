-- ---------------------------------------------------------
-- Prepares final tnrs results table
-- ---------------------------------------------------------

set search_path to :sch;

-- Insert the text candidate FK
TRUNCATE tnrs;
INSERT INTO tnrs (
name_submitted_verbatim,
name_submitted
) 
SELECT 
name_submitted_verbatim,
name_submitted
FROM tnrs_submitted
;

DROP INDEX IF EXISTS tnrs_name_submitted_verbatim_idx;
CREATE UNIQUE INDEX tnrs_name_submitted_verbatim_idx ON tnrs (name_submitted_verbatim)
;
DROP INDEX IF EXISTS tnrs_name_submitted_idx;
CREATE UNIQUE INDEX tnrs_name_submitted_idx ON tnrs (name_submitted)
;

-- Add basic results
UPDATE tnrs a
SET
name_submitted=b.name_submitted,
tnrs_name_matched_score=b.overall_score::numeric,
tnrs_warning=
case when trim(b.warnings)='' OR b.warnings is null then null
else trim(b.warnings)
end,
matched_taxonomic_status=
case when trim(b.taxonomic_status)='' OR b.taxonomic_status is null then null
else trim(b.taxonomic_status)
end,
sources=b."source"
FROM tnrs_scrubbed b
WHERE a.name_submitted=b.name_submitted
AND selected='true'
;

-- matched name
UPDATE tnrs a
SET 
family_matched=TRIM(b.name_matched_accepted_family),
name_matched=TRIM(b.name_matched),
name_matched_author=TRIM(b.name_matched_author),
matched_taxonomic_status=b.taxonomic_status
FROM tnrs_scrubbed b
WHERE a.name_submitted=b.name_submitted 
AND b.selected='true'
;

-- accepted name
UPDATE tnrs a
SET 
scrubbed_family=TRIM(b.accepted_name_family),
scrubbed_genus=
CASE
WHEN b.accepted_name_rank='genus' THEN TRIM(b.accepted_name)
ELSE TRIM(split_part(b.accepted_name_species,' ',1))
END,
scrubbed_specific_epithet=TRIM(split_part(b.accepted_name_species,' ',2)),
scrubbed_species_binomial=TRIM(b.accepted_name_species),
scrubbed_taxon_name_no_author=TRIM(b.accepted_name),
scrubbed_author=TRIM(b.accepted_name_author),
scrubbed_taxon_name_with_author=TRIM(CONCAT_WS(' ', b.accepted_name, b.accepted_name_author)),
scrubbed_species_binomial_with_morphospecies=TRIM(CONCAT_WS(' ', b.accepted_name, b.unmatched_terms)),
scrubbed_taxonomic_status='Accepted'
FROM tnrs_scrubbed b
WHERE a.name_submitted=b.name_submitted 
AND b.selected='true'
AND b.accepted_name IS NOT NULL
;

-- use matched name as accepted name if no accepted name found
UPDATE tnrs a
SET 
scrubbed_family=TRIM(b.name_matched_accepted_family),
scrubbed_genus=TRIM(b.genus_matched),
scrubbed_specific_epithet=TRIM(b.specific_epithet_matched),
scrubbed_species_binomial=
CASE
WHEN b.specific_epithet_matched IS NOT NULL THEN TRIM(CONCAT_WS(' ',TRIM(b.genus_matched), TRIM(b.specific_epithet_matched)))
ELSE NULL
END,
scrubbed_taxon_name_no_author=TRIM(b.name_matched),
scrubbed_author=TRIM(b.author_matched),
scrubbed_taxon_name_with_author=TRIM(CONCAT_WS(' ', TRIM(b.name_matched), TRIM(b.author_matched))),
scrubbed_species_binomial_with_morphospecies=TRIM(CONCAT_WS(' ', TRIM(CONCAT_WS(' ',TRIM(b.genus_matched), TRIM(b.specific_epithet_matched))), TRIM(b.unmatched_terms))),
scrubbed_taxonomic_status=matched_taxonomic_status
FROM tnrs_scrubbed b
WHERE a.name_submitted=b.name_submitted 
AND b.selected='true'
AND b.accepted_name IS NULL
;

DROP INDEX IF EXISTS tnrs_scrubbed_family_idx;
CREATE INDEX tnrs_scrubbed_family_idx ON tnrs (scrubbed_family)
;
DROP INDEX IF EXISTS tnrs_scrubbed_taxon_name_no_author_idx;
CREATE INDEX tnrs_scrubbed_taxon_name_no_author_idx ON tnrs (scrubbed_taxon_name_no_author)
;

-- Correct scrubbed family when taxon matched to family only
UPDATE tnrs
SET scrubbed_family=scrubbed_taxon_name_no_author
WHERE scrubbed_family IS NULL
AND scrubbed_taxon_name_no_author LIKE '%aceae'
;

-- Canonical name
UPDATE tnrs 
SET scrubbed_taxon_canonical=
CASE
WHEN scrubbed_taxon_name_no_author LIKE '%var.%' THEN REPLACE(scrubbed_taxon_name_no_author,'var. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%subsp.%' THEN REPLACE(scrubbed_taxon_name_no_author,'subsp. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%fo.%' THEN REPLACE(scrubbed_taxon_name_no_author,'fo. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%cv.%' THEN REPLACE(scrubbed_taxon_name_no_author,'cv. ','')
ELSE scrubbed_taxon_name_no_author
END
;

-- Fix some mix weird errors
UPDATE tnrs
SET scrubbed_genus='Diospyros',
scrubbed_species_binomial=REPLACE(scrubbed_species_binomial,'diospyros','Diospyros')
WHERE scrubbed_taxon_name_no_author LIKE 'Diospyros%'
;

UPDATE tnrs
SET scrubbed_specific_epithet=lower(scrubbed_specific_epithet),
scrubbed_species_binomial=scrubbed_taxon_name_no_author
WHERE NOT(scrubbed_species_binomial=scrubbed_taxon_name_no_author)
AND lower(scrubbed_species_binomial)=lower(scrubbed_taxon_name_no_author)
;

-- Standardize hybrid x
-- This should be done by TNRS but for some reason isn't
UPDATE tnrs
SET scrubbed_genus=REPLACE(scrubbed_genus,'×','x')
WHERE scrubbed_genus LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_specific_epithet=REPLACE(scrubbed_specific_epithet,'×','x')
WHERE scrubbed_specific_epithet LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_species_binomial=REPLACE(scrubbed_species_binomial,'×','x')
WHERE scrubbed_species_binomial LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_taxon_name_no_author=REPLACE(scrubbed_taxon_name_no_author,'×','x')
WHERE scrubbed_taxon_name_no_author LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,'×','x')
WHERE scrubbed_taxon_canonical LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_taxon_name_with_author=REPLACE(scrubbed_taxon_name_with_author,'×','x')
WHERE scrubbed_taxon_name_with_author LIKE '%×%'
;
UPDATE tnrs
SET scrubbed_species_binomial_with_morphospecies=REPLACE(scrubbed_species_binomial_with_morphospecies,'×','x')
WHERE scrubbed_species_binomial_with_morphospecies LIKE '%×%'
;
UPDATE tnrs
SET name_matched=REPLACE(name_matched,'×','x')
WHERE name_matched LIKE '%×%'
;

-- remove hybrid x between epithets
UPDATE tnrs 
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,'× ','')
WHERE scrubbed_taxon_canonical LIKE '%× %' 
;

-- remove hybrid x appended to an epithet
UPDATE tnrs 
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,'×','')
WHERE scrubbed_taxon_canonical LIKE '%×%' 
;

-- Fix hybrid species
UPDATE tnrs
SET scrubbed_specific_epithet=concat('x ',split_part(scrubbed_species_binomial,' x ', 2))
WHERE scrubbed_species_binomial like '% x %'
;

-- Fix hybrid genera
UPDATE tnrs
SET 
scrubbed_genus=concat('x ',split_part(scrubbed_species_binomial,' ', 2)),
scrubbed_specific_epithet=split_part(scrubbed_species_binomial,' ', 3)
WHERE scrubbed_species_binomial like 'x % %'
;

-- Standardize partial match warnings
UPDATE tnrs a
SET tnrs_warning='Partial match only'
WHERE tnrs_warning LIKE '%Partial match%'
;