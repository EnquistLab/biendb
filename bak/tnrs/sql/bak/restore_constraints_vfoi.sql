-- ------------------------------------------------------------------
-- Restore constraints on production tables
-- Note that FK constraint from nsr (child) to vfoi (parent) is not
-- restored. This is because some records present in nsr have been
-- removed from vfoi by embargoes. I see no point in deleting these
-- records from nsr, but need to be aware of this potential anomaly.
-- ------------------------------------------------------------------

\c public_vegbien
SET search_path TO public;

-- 
-- Restore FK constraints to parent tables
-- 

BEGIN;

LOCK TABLE view_full_occurrence_individual IN SHARE MODE;

ALTER TABLE ONLY view_full_occurrence_individual
ADD CONSTRAINT vfoi_plot_metadata_id_fkey 
FOREIGN KEY (plot_metadata_id) REFERENCES plot_metadata (plot_metadata_id);

ALTER TABLE ONLY view_full_occurrence_individual
ADD CONSTRAINT vfoi_datasource_id_fkey 
FOREIGN KEY (datasource_id) REFERENCES datasource (datasource_id);

ALTER TABLE ONLY view_full_occurrence_individual
ADD CONSTRAINT vfoi_bien_taxonomy_id_fkey 
FOREIGN KEY (bien_taxonomy_id) REFERENCES bien_taxonomy (bien_taxonomy_id);

COMMIT;

-- 
-- Restore FK constraints in child tables
-- 

-- analytical_stem
BEGIN;

LOCK TABLE analytical_stem IN SHARE MODE;

ALTER TABLE ONLY analytical_stem
ADD CONSTRAINT analytical_stem_taxonobservation_id_fkey 
FOREIGN KEY (taxonobservation_id) 
REFERENCES view_full_occurrence_individual(taxonobservation_id);

COMMIT;

-- nsr
BEGIN;


