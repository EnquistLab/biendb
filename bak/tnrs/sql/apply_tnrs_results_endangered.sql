-- ---------------------------------------------------------
-- Apply tnrs results to table endangered_taxa_by_source
--
-- NOTE: Uses parsed name, not resolved name!
-- Resolution results used only to update family
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Note use of TRIM
-- Stupid TNRS returns trailing whitespace!
UPDATE endangered_taxa_by_source a
SET 
genus_scrubbed=TRIM(b.genus),
species_binomial_scrubbed=TRIM(b.specific_epithet),
taxon_scrubbed=TRIM(b.taxon_name),
taxon_scrubbed_canonical=TRIM(b.canonical_name),
taxon_rank=TRIM(b.taxon_parsed_rank)
FROM tnrs_parsed b
WHERE a.verbatim_taxon=b.name_submitted
;

-- accepted matched family
UPDATE endangered_taxa_by_source a
SET family_scrubbed=TRIM(b.name_matched_accepted_family)
FROM tnrs_scrubbed b
WHERE a.verbatim_taxon=b.name_submitted 
AND b.selected='true'
;

-- accepted family, needed for cases where no family 
-- included in verbatim name, therefore no family matched
UPDATE endangered_taxa_by_source a
SET family_scrubbed=TRIM(b.accepted_name_family)
FROM tnrs_scrubbed b
WHERE a.verbatim_taxon=b.name_submitted 
AND b.selected='true'
AND (a.family_scrubbed IS NULL OR a.family_scrubbed='')
;

