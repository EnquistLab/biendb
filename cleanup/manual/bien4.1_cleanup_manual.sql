-- -----------------------------------------------------------------
-- Manual cleanup after running corrections on completed development
-- private database
-- -----------------------------------------------------------------

\c vegbien
set search_path to analytical_db_dev;

-- Remove 'dev' suffix from major tables
alter table analytical_stem_dev rename to analytical_stem;
alter table view_full_occurrence_individual_dev rename to view_full_occurrence_individual;

-- Drop unneeded tables
DROP TABLE analytical_stem_temp;
DROP TABLE datasource_bak;
DROP TABLE dd_cols_prev;
DROP TABLE dd_tables_prev;
DROP TABLE dd_vals_columns_prev;
DROP TABLE dd_vals_prev;
-- DROP TABLE tnrs_scrubbed;
DROP TABLE tnrs_copy;

-- Drop sequences
ALTER TABLE bien_summary ALTER COLUMN bien_summary_id DROP DEFAULT;
DROP SEQUENCE bien_summary_bien_summary_id_seq;

ALTER TABLE observations_union ALTER COLUMN gid DROP DEFAULT;
DROP SEQUENCE observations_union_gid_seq;

ALTER TABLE species_by_political_division ALTER COLUMN species_by_political_division_id DROP DEFAULT;
DROP SEQUENCE species_by_political_division_species_by_political_division_seq;

ALTER TABLE species ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE species_id_seq;

ALTER TABLE pdg ALTER COLUMN pdg_id DROP DEFAULT;
DROP SEQUENCE pdg_pdg_id_seq;

-- Remove unwanted entries from data dictionary
DELETE FROM data_dictionary_tables WHERE table_name IN (
'dd_cols_prev',
'dd_tables_prev',
'dd_vals_columns_prev',
'dd_vals_prev',
'gbif_occurrence_raw',
'ic_temp',
'tnrs_submitted'
)
;
DELETE FROM data_dictionary_columns WHERE table_name IN (
'dd_cols_prev',
'dd_tables_prev',
'dd_vals_columns_prev',
'dd_vals_prev',
'gbif_occurrence_raw',
'ic_temp',
'tnrs_submitted'
)
;

-- Add new columns to data dictionary
INSERT INTO data_dictionary_columns (
table_name, ordinal_position, column_name, data_type, can_be_null
)
VALUES 
('agg_traits', 47, 'centroid_max_uncertainty', 'numeric', 'YES'),
('analytical_stem', 30, 'centroid_max_uncertainty', 'numeric', 'YES'),
('view_full_occurrence_individual', 30, 'centroid_max_uncertainty', 'numeric', 'YES')
;

UPDATE data_dictionary_columns
SET column_name='centroid_dist_relative'
WHERE column_name='centroid_likelihood'
;

UPDATE data_dictionary_values
SET definition='No information from data provider indicating how coordinates were georeferenced'
WHERE column_name='georef_protocol'
;


