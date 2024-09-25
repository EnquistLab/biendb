-- --------------------------------------------------------------------
-- Temporary fix only for BIEN 4.0. Replace with "filter_rainbio.sql"
-- once data providers have been added and linked to observations
-- --------------------------------------------------------------------

SET search_path TO :sch;

DELETE FROM :sch.agg_traits a
USING :sch.view_full_occurrence_individual b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND b.datasource='rainbio';

DELETE FROM :sch.analytical_stem WHERE datasource='rainbio';

DELETE FROM :sch.view_full_occurrence_individual WHERE datasource='rainbio';