-- --------------------------------------------------------------------
-- Removes REMIB records from the public view_full_occurrence_individual
-- --------------------------------------------------------------------

SET search_path TO :sch;

DELETE FROM :sch.agg_traits a
USING :sch.view_full_occurrence_individual b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND b.datasource='REMIB';

DELETE FROM :sch.view_full_occurrence_individual 
WHERE datasource='REMIB';
