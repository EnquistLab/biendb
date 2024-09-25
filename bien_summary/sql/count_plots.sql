-- 
-- Adds count of all plots to table bien_summary
--

SET search_path TO :dev_schema;

UPDATE bien_summary 
SET plot_count=(
SELECT COUNT( DISTINCT CONCAT(datasource, dataset, plot_name) ) 
FROM plot_metadata
WHERE plot_name IS NOT NULL
)
;
