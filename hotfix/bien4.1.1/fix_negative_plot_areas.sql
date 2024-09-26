-- ---------------------------------------------------------------
-- Set 0 or negative plot areas to NULL
-- 
-- DB incremented to 4.1.1 after this change
-- ADDED TO BIEN 4.2 PIPELINE
-- ---------------------------------------------------------------

SET search_path TO :sch;

UPDATE plot_metadata
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;

UPDATE view_full_occurrence_individual
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;

UPDATE analytical_stem
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;