-- ----------------------------------------------------------------
-- Create development copy of vfoi with updated plot codes
-- Parameter :reclim is for testing only
-- ----------------------------------------------------------------

SET search_path TO :sch;

UPDATE view_full_occurrence_individual_dev a
SET plot_name=b.plot_name_new
FROM fia_plot_codes b
WHERE a.datasource='FIA'
AND a.taxonobservation_id=b.taxonobservation_id
;