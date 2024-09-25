-- 
-- Adds count of all plots to table bien_summary_public
--

SET search_path TO :dev_schema;

UPDATE bien_summary_public 
SET plot_count=(
SELECT COUNT( DISTINCT CONCAT(datasource, dataset, plot_name) ) 
FROM plot_metadata
WHERE plot_name IS NOT NULL
)
WHERE bien_summary_public_id=(
SELECT MAX(bien_summary_public_id) FROM bien_summary_public
)
;
