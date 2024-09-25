-- ---------------------------------------------------------------------
-- Remove legacy data sources that will be imported again later
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Delete the records
-- 

DELETE FROM datasource
WHERE proximate_provider_name IN (:src_list)
;

DELETE FROM plot_metadata
WHERE datasource IN (:src_list)
;

DELETE FROM view_full_occurrence_individual_dev
WHERE datasource IN (:src_list)
;

DELETE FROM analytical_stem_dev
WHERE datasource IN (:src_list)
;
