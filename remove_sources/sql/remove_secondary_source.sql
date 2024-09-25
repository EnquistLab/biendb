-- ---------------------------------------------------------------------
-- Remove records of a primary provider source where provided secondarily 
-- a different primary source or aggregator
-- 
-- Make sure columns in WHERE clause are indexed!
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Delete the records
-- 

DELETE FROM datasource
WHERE source_name=:'primary_src'
AND proximate_provider_name<>:'primary_src'
;

DELETE FROM plot_metadata
WHERE dataset=:'primary_src'
AND datasource<>:'primary_src'
;

DELETE FROM view_full_occurrence_individual_dev
WHERE dataset=:'primary_src'
AND datasource<>:'primary_src'
;

DELETE FROM analytical_stem_dev
WHERE dataset=:'primary_src'
AND datasource<>:'primary_src'
;

