-- --------------------------------------------------------------------
-- Removes New Zealand NVS plot data from the public database
-- --------------------------------------------------------------------

SET search_path TO :sch;

DELETE FROM :sch.agg_traits a
USING :sch.view_full_occurrence_individual b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND b.datasource='NVS';

DELETE FROM :sch.analytical_stem WHERE datasource='NVS';

DELETE FROM :sch.view_full_occurrence_individual WHERE datasource='NVS';