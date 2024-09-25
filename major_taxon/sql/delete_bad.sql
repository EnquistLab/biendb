-- --------------------------------------------------------------
-- Delete all non-Embryophyte names, except for CVS and VegBank
-- --------------------------------------------------------------

SET search_path TO :sch;

DELETE FROM agg_traits a
USING tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id 
AND (b.major_taxon<>'Embryophyta' OR b.name_submitted ILIKE '%idae %')
;

DELETE FROM analytical_stem_dev a
USING tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id 
AND a.datasource NOT IN ('VegBank','CVS')
AND b.major_taxon<>'Embryophyta'
;

DELETE FROM analytical_stem_dev 
WHERE name_submitted ILIKE '%idae %'
;

DELETE FROM view_full_occurrence_individual_dev a
USING tnrs b
WHERE a.fk_tnrs_id=b.tnrs_id 
AND a.datasource NOT IN ('VegBank','CVS')
AND b.major_taxon<>'Embryophyta'
;

DELETE FROM view_full_occurrence_individual_dev
WHERE name_submitted ILIKE '%idae %'
;

-- drop unneeded indexes
DROP INDEX IF EXISTS analytical_stem_dev_datasource_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_datasource_idx;
