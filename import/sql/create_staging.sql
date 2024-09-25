-- 
-- Creates staging tables
--

SET search_path TO :sch;

-- view_full_occurrence_individual
-- Add PK but do NOT make autoincrement
-- This allows PK to be inserted from raw plot data, for later joining
-- to analytical_stem_staging. To avoid confusion, new column is added 
-- rather than using PK taxonobservation_id from source table. 
-- Raw plot data MUST have valid integer PK for this method to 
-- work; add one if necessary.
DROP TABLE IF EXISTS vfoi_staging;
CREATE TABLE vfoi_staging (LIKE view_full_occurrence_individual_dev);
ALTER TABLE vfoi_staging ALTER taxonobservation_id DROP NOT NULL;
ALTER TABLE vfoi_staging ADD COLUMN vfoi_staging_id BIGSERIAL PRIMARY KEY;
ALTER TABLE vfoi_staging ADD COLUMN datasource_staging_id INTEGER DEFAULT NULL;

-- analytical_stem
-- Index FK column to vfoi_staging
DROP TABLE IF EXISTS analytical_stem_staging;
CREATE TABLE analytical_stem_staging (LIKE analytical_stem_dev);
ALTER TABLE analytical_stem_staging ADD COLUMN vfoi_staging_id BIGINT NOT NULL;
ALTER TABLE analytical_stem_staging ADD COLUMN datasource_staging_id INTEGER DEFAULT NULL;

-- plot_metadata 
-- Dropping NOT NULL constraint on plot_metadata_id as well will be using
-- plot_name as candidate PK. This will also serve as a check at loading
-- that the plot codes are unique
DROP TABLE IF EXISTS plot_metadata_staging;
CREATE TABLE plot_metadata_staging (LIKE plot_metadata);
ALTER TABLE plot_metadata_staging ALTER plot_metadata_id DROP NOT NULL;
ALTER TABLE plot_metadata_staging ADD PRIMARY KEY (plot_name);

-- metadata staging table in final format, same as datasource but
-- minus FKs, and all datatypes text except for PK
DROP TABLE IF EXISTS datasource_staging;
CREATE TABLE datasource_staging (
datasource_staging_id serial primary key,
datasource_id integer,
source_name text,
source_fullname text,
source_type text,
observation_type text,
is_herbarium text default '0',
proximate_provider_name text,
proximate_provider_datasource_staging_id integer,
proximate_provider_datasource_id integer,
primary_contact_institution_name text,
primary_contact_firstname text,
primary_contact_lastname text,
primary_contact_fullname text,
primary_contact_email text,
source_url text,
source_citation text,
access_conditions text,
access_level text,
locality_error_added text,
locality_error_details text
);