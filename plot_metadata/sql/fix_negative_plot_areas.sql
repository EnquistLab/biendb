-- ---------------------------------------------------------------
-- Set 0 or negative plot areas to NULL
-- From manual_fixes/bien4.1.1
-- Do not run during main module plot_metadata! Instead run as
-- separate update toward end of pipeline step 3 but before
-- indexing main adb tables.
-- Be sure to remove all indexes except PK before running
-- ---------------------------------------------------------------

SET search_path TO :sch;

UPDATE plot_metadata
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;

UPDATE view_full_occurrence_individual_dev
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;

UPDATE analytical_stem_dev
SET plot_area_ha=NULL
WHERE plot_area_ha<=0
;