-- ---------------------------------------------------------
-- Applies tnrs results to endangered species table
-- WARNING: this version uses parsed name, not resolved name!
-- Resolution results used only to update family
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

-- Note use of TRIM
-- Stupid TNRS returns trailing whitespace!
UPDATE endangered_taxa_by_source a
SET 
genus_scrubbed=TRIM(b.genus),
species_binomial_scrubbed=TRIM(b.specific_epithet),
taxon_scrubbed=TRIM(b.taxon_name),
taxon_scrubbed_canonical=TRIM(b.canonical_name),
taxon_rank=TRIM(b.taxon_parsed_rank)
FROM taxon_verbatim_parsed b
WHERE a.endangered_taxa_by_source_id=b.user_id
;

-- accepted matched family
UPDATE endangered_taxa_by_source a
SET family_scrubbed=TRIM(b.name_matched_accepted_family)
FROM taxon_verbatim_scrubbed b
WHERE a.endangered_taxa_by_source_id=b.user_id AND b.selected='true'
;

-- accepted family, needed for cases where no family 
-- included in verbatim name, therefore no family matched
UPDATE endangered_taxa_by_source a
SET family_scrubbed=TRIM(b.accepted_name_family)
FROM taxon_verbatim_scrubbed b
WHERE a.endangered_taxa_by_source_id=b.user_id AND b.selected='true'
AND 
(a.family_scrubbed IS NULL OR a.family_scrubbed='')
;

