-- 
-- Adds count of all plot observations to table bien_summary_public
--

SET search_path TO :dev_schema;

UPDATE bien_summary_public 
SET plot_obs_count=(
SELECT COUNT(*) 
FROM view_full_occurrence_individual
WHERE observation_type='plot'
)
WHERE bien_summary_public_id=(
SELECT MAX(bien_summary_public_id) FROM bien_summary_public
)
;
