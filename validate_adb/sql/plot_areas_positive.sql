-- ------------------------------------------------------------
-- Check that plot areas always >1
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT NOT EXISTS (
SELECT datasource, dataset, plot_name, plot_area_ha 
FROM :tbl 
WHERE plot_area_ha<=0
LIMIT 1
) AS plot_areas_positive
;
