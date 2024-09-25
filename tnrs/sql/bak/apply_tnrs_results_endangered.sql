-- ---------------------------------------------------------
-- Apply tnrs results to table endangered_taxa_by_source
--
-- NOTE: Uses matched name, not accepted name!
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Note use of TRIM
UPDATE endangered_taxa_by_source a
SET 
family_scrubbed=TRIM(b.name_matched_accepted_family),
genus_scrubbed=TRIM(b.genus_matched),
species_binomial_scrubbed=TRIM(CONCAT_WS(' ',
TRIM(b.genus_matched),TRIM(b.specific_epithet_matched)
)),
taxon_scrubbed=TRIM(b.name_matched),
taxon_scrubbed_canonical=TRIM(CONCAT_WS(' ',
TRIM(b.genus_matched),TRIM(b.specific_epithet_matched),TRIM(b.infraspecific_epithet_matched)
)),
taxon_rank=TRIM(b.name_matched_rank)
FROM tnrs_scrubbed b
WHERE a.verbatim_taxon=b.name_submitted
AND b.selected='true'
;