-- 
-- Adds count of all plot observations to table bien_summary
--

SET search_path TO :dev_schema;

UPDATE bien_summary 
SET plot_obs_count=(
SELECT COUNT(*) 
FROM view_full_occurrence_individual_dev
WHERE observation_type='plot'
)
WHERE bien_summary_id=(
SELECT MAX(bien_summary_id) FROM bien_summary
)
;
