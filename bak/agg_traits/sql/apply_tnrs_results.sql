-- ---------------------------------------------------------
-- Applies tnrs results
-- ---------------------------------------------------------

set search_path to :dev_schema;

-- matched name
UPDATE agg_traits a
SET 
family_matched=TRIM(b.name_matched_accepted_family),
name_matched=TRIM(b.name_matched),
name_matched_author=TRIM(b.name_matched_author),
matched_taxonomic_status=b.taxonomic_status
FROM taxon_verbatim_scrubbed b
WHERE a.fk_tnrs_user_id=b.user_id 
AND b.selected='true'
;

-- accepted name
UPDATE agg_traits a
SET 
scrubbed_family=TRIM(b.accepted_name_family),
scrubbed_genus=TRIM(split_part(b.accepted_name_species,' ',1)),
scrubbed_specific_epithet=TRIM(split_part(b.accepted_name_species,' ',2)),
scrubbed_species_binomial=TRIM(b.accepted_name_species),
scrubbed_taxon_name_no_author=TRIM(b.accepted_name),
scrubbed_author=TRIM(b.accepted_name_author),
scrubbed_taxon_name_with_author=TRIM(CONCAT_WS(' ', b.accepted_name, b.accepted_name_author)),
scrubbed_species_binomial_with_morphospecies=TRIM(CONCAT_WS(' ', b.accepted_name, b.unmatched_terms)),
scrubbed_taxonomic_status='Accepted'
FROM taxon_verbatim_scrubbed b
WHERE a.fk_tnrs_user_id=b.user_id 
AND b.accepted_name IS NOT NULL
AND b.selected='true'
;

-- matched name if no accepted name found
UPDATE agg_traits a
SET 
scrubbed_family=TRIM(b.name_matched_accepted_family),
scrubbed_genus=TRIM(b.genus_matched),
scrubbed_specific_epithet=TRIM(b.specific_epithet_matched),
scrubbed_species_binomial=TRIM(CONCAT_WS(' ',TRIM(b.genus_matched), TRIM(b.specific_epithet_matched))),
scrubbed_taxon_name_no_author=TRIM(b.name_matched),
scrubbed_author=TRIM(b.author_matched),
scrubbed_taxon_name_with_author=TRIM(CONCAT_WS(' ', TRIM(b.name_matched), TRIM(b.author_matched))),
scrubbed_species_binomial_with_morphospecies=TRIM(CONCAT_WS(' ', TRIM(CONCAT_WS(' ',TRIM(b.genus_matched), TRIM(b.specific_epithet_matched))), b.unmatched_terms)),
scrubbed_taxonomic_status=matched_taxonomic_status
FROM taxon_verbatim_scrubbed b
WHERE a.fk_tnrs_user_id=b.user_id 
AND b.accepted_name IS NULL
AND b.selected='true'
;

-- Correct scrubbed family when taxon matched to family only
UPDATE agg_traits
SET scrubbed_family=scrubbed_taxon_name_no_author
WHERE scrubbed_family IS NULL
AND scrubbed_taxon_name_no_author LIKE '%aceae'
;

-- Canonical name
UPDATE agg_traits 
SET scrubbed_taxon_canonical=
CASE
WHEN scrubbed_taxon_name_no_author LIKE '%var.%' THEN REPLACE(scrubbed_taxon_name_no_author,'var. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%subsp.%' THEN REPLACE(scrubbed_taxon_name_no_author,'subsp. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%fo.%' THEN REPLACE(scrubbed_taxon_name_no_author,'fo. ','')
WHEN scrubbed_taxon_name_no_author LIKE '%cv.%' THEN REPLACE(scrubbed_taxon_name_no_author,'cv. ','')
ELSE scrubbed_taxon_name_no_author
END
;
-- remove hybrid x between epithets
UPDATE agg_traits 
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,'× ','')
WHERE scrubbed_taxon_canonical LIKE '%× %' 
;
-- remove hybrid x appended to an epithet
UPDATE agg_traits 
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,'×','')
WHERE scrubbed_taxon_canonical LIKE '%×%' 
;

-- Flag partial matches
UPDATE agg_traits a
SET tnrs_warning='Partial match only'
FROM taxon_verbatim_scrubbed b
WHERE a.fk_tnrs_user_id=b.user_id 
AND b.selected='true'
AND b.warnings LIKE '%Partial match%'
;