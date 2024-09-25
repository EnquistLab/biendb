-- --------------------------------------------------------------------
-- Removes deleted sources from metadata tables
-- --------------------------------------------------------------------

SET search_path TO :sch;

DELETE FROM datasource 
WHERE proximate_provider_name IN ('Madidi','NVS','REMIB')
;

DELETE FROM plot_metadata 
WHERE datasource IN ('Madidi','NVS','REMIB')
;

