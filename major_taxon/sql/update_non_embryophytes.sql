-- --------------------------------------------------------------
-- Update remaining non-Embryophyte names, currently just 
-- CVS and VegBank. Make sure delete any unwanted higher taxa and
-- their observations first (e.g., animals) otherwise this will
-- be too slow.
-- NOTE: This is a temporary hack added to end of pipeline, ultimately
-- need to resolve and then remove non-plant names early in pipeline, 
-- before build taxonomy tables or scrub with NSR, etc.
-- This hack will result in missing entries from bien_taxonomy for
-- any updated names.
-- --------------------------------------------------------------

SET search_path TO :sch;


-- Add columns to tnrs
ALTER TABLE tnrs DROP COLUMN IF EXISTS higher_plant_group_orig;
ALTER TABLE tnrs ADD COLUMN higher_plant_group_orig text default null;

ALTER TABLE tnrs DROP COLUMN IF EXISTS higher_plant_group;
ALTER TABLE tnrs ADD COLUMN higher_plant_group text default null;

-- Create indexes on major tables

DROP INDEX IF EXISTS agg_traits_higher_plant_group_isnotnull_idx;
CREATE INDEX agg_traits_higher_plant_group_isnotnull_idx ON agg_traits (higher_plant_group) WHERE higher_plant_group IS NOT NULL;

DROP INDEX IF EXISTS vfoi_dev_higher_plant_group_isnotnull_idx;
CREATE INDEX vfoi_dev_higher_plant_group_isnotnull_idx ON view_full_occurrence_individual_dev (higher_plant_group) WHERE higher_plant_group IS NOT NULL;

-- 
-- Transfer existing values of higher_plant_group from main tables
-- & update
-- 

UPDATE tnrs a
SET 
higher_plant_group_orig=b.higher_plant_group,
higher_plant_group=b.higher_plant_group
FROM view_full_occurrence_individual_dev b
WHERE a.tnrs_id=b.fk_tnrs_id
AND b.higher_plant_group IS NOT NULL
;

UPDATE tnrs a
SET 
higher_plant_group_orig=b.higher_plant_group,
higher_plant_group=b.higher_plant_group
FROM agg_traits b
WHERE a.tnrs_id=b.fk_tnrs_id
AND b.higher_plant_group IS NOT NULL
AND a.higher_plant_group IS NULL
;

UPDATE tnrs
SET 
higher_plant_group=major_taxon
WHERE major_taxon<>'Embryophyta'
;

-- Update higher_plant_group
UPDATE tnrs 
SET higher_plant_group=major_taxon
WHERE major_taxon<>'Embryophyta'
;

DROP INDEX IF EXISTS tnrs_higher_plant_group_idx;
CREATE INDEX tnrs_higher_plant_group_idx ON tnrs (higher_plant_group);
DROP INDEX IF EXISTS tnrs_higher_plant_group_orig_idx;
CREATE INDEX tnrs_higher_plant_group_orig_idx ON tnrs (higher_plant_group_orig);

-- 
-- Update higher_plant_group in main tables for all non-embryophytes
-- 

UPDATE view_full_occurrence_individual_dev a
SET higher_plant_group=b.higher_plant_group
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
;
UPDATE analytical_stem_dev a
SET higher_plant_group=b.higher_plant_group
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
;
UPDATE agg_traits a
SET higher_plant_group=b.higher_plant_group
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
;

-- 
-- Change full taxonomy to NCBI name where TNRS erroneously 
-- corrected to non-embryophyte to embryophyte name, as indicated
-- by non-null value of higher_plant_group_orig
-- 

UPDATE tnrs
SET
bien_taxonomy_id=NULL,
taxon_id=NULL,
family_taxon_id=NULL,
genus_taxon_id=NULL,
species_taxon_id=NULL,
family_matched=family_submitted,
name_matched=species_submitted,
name_matched_author=NULL,
name_matched_rank='species',
tnrs_name_matched_score=1.0,
matched_taxonomic_status='No opinion',
annotations=NULL,
unmatched_terms=REPLACE(name_submitted,species_submitted,''),
scrubbed_taxonomic_status='No opinion',
scrubbed_family=family_submitted,
scrubbed_genus=genus_submitted,
scrubbed_specific_epithet=specific_epithet_submitted,
scrubbed_species_binomial=species_submitted,
scrubbed_taxon_name_no_author=species_submitted,
scrubbed_taxon_canonical=species_submitted,
scrubbed_author=NULL,
scrubbed_taxon_name_with_author=species_submitted,
scrubbed_species_binomial_with_morphospecies=name_submitted,
sources='ncbi',
tnrs_warning='TNRS results replaced by exact match from NCBI',
tnrs_match_summary='Exact match',
tnrs_author_matched_score=NULL
WHERE major_taxon<>'Embryophyta'
AND higher_plant_group_orig IS NOT NULL
;

UPDATE view_full_occurrence_individual_dev a
SET 
bien_taxonomy_id=b.bien_taxonomy_id,
taxon_id=b.taxon_id::integer,
family_taxon_id=b.family_taxon_id::integer,
genus_taxon_id=b.genus_taxon_id::integer,
species_taxon_id=b.species_taxon_id::integer,
family_matched=b.family_matched,
name_matched=b.name_matched,
name_matched_author=b.name_matched_author,
tnrs_name_matched_score=b.tnrs_name_matched_score,
tnrs_warning=b.tnrs_warning,
matched_taxonomic_status=b.matched_taxonomic_status,
match_summary=b.tnrs_match_summary,
scrubbed_taxonomic_status=b.scrubbed_taxonomic_status,
higher_plant_group=b.higher_plant_group,
scrubbed_family=b.scrubbed_family,
scrubbed_genus=b.scrubbed_genus,
scrubbed_specific_epithet=b.scrubbed_specific_epithet,
scrubbed_species_binomial=b.scrubbed_species_binomial,
scrubbed_taxon_name_no_author=b.scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical=b.scrubbed_taxon_canonical,
scrubbed_author=b.scrubbed_author,
scrubbed_taxon_name_with_author=b.scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies=b.scrubbed_species_binomial_with_morphospecies
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
AND b.higher_plant_group_orig IS NOT NULL
;

UPDATE analytical_stem_dev a
SET 
bien_taxonomy_id=b.bien_taxonomy_id,
taxon_id=b.taxon_id::integer,
family_taxon_id=b.family_taxon_id::integer,
genus_taxon_id=b.genus_taxon_id::integer,
species_taxon_id=b.species_taxon_id::integer,
family_matched=b.family_matched,
name_matched=b.name_matched,
name_matched_author=b.name_matched_author,
tnrs_name_matched_score=b.tnrs_name_matched_score,
tnrs_warning=b.tnrs_warning,
matched_taxonomic_status=b.matched_taxonomic_status,
match_summary=b.tnrs_match_summary,
scrubbed_taxonomic_status=b.scrubbed_taxonomic_status,
higher_plant_group=b.higher_plant_group,
scrubbed_family=b.scrubbed_family,
scrubbed_genus=b.scrubbed_genus,
scrubbed_specific_epithet=b.scrubbed_specific_epithet,
scrubbed_species_binomial=b.scrubbed_species_binomial,
scrubbed_taxon_name_no_author=b.scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical=b.scrubbed_taxon_canonical,
scrubbed_author=b.scrubbed_author,
scrubbed_taxon_name_with_author=b.scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies=b.scrubbed_species_binomial_with_morphospecies
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
AND b.higher_plant_group_orig IS NOT NULL
;

UPDATE agg_traits a
SET 
bien_taxonomy_id=b.bien_taxonomy_id,
taxon_id=b.taxon_id::integer,
family_taxon_id=b.family_taxon_id::integer,
genus_taxon_id=b.genus_taxon_id::integer,
species_taxon_id=b.species_taxon_id::integer,
family_matched=b.family_matched,
name_matched=b.name_matched,
name_matched_author=b.name_matched_author,
tnrs_name_matched_score=b.tnrs_name_matched_score,
tnrs_warning=b.tnrs_warning,
matched_taxonomic_status=b.matched_taxonomic_status,
match_summary=b.tnrs_match_summary,
scrubbed_taxonomic_status=b.scrubbed_taxonomic_status,
higher_plant_group=b.higher_plant_group,
scrubbed_family=b.scrubbed_family,
scrubbed_genus=b.scrubbed_genus,
scrubbed_specific_epithet=b.scrubbed_specific_epithet,
scrubbed_species_binomial=b.scrubbed_species_binomial,
scrubbed_taxon_name_no_author=b.scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical=b.scrubbed_taxon_canonical,
scrubbed_author=b.scrubbed_author,
scrubbed_taxon_name_with_author=b.scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies=b.scrubbed_species_binomial_with_morphospecies
FROM tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id
AND b.major_taxon<>'Embryophyta'
AND b.higher_plant_group_orig IS NOT NULL
;