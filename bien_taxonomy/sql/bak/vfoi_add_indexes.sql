-- -------------------------------------------------------------
-- Generate indexes present in original table vfoi
--
-- Note 1: does not include dependent table FKs. These are generated
--   later in production schema, after replacement of original table
--   by developement table
-- Note 2: must include schema for postgis functions st_ndims()
--   and geometrytype()
-- -------------------------------------------------------------

SET search_path TO :dev_schema;

-- Index the integer FK to taxonomy table
CREATE INDEX vfoi_bien_taxonomy_id_idx ON view_full_occurrence_individual_dev(bien_taxonomy_id);
        
CREATE INDEX vfoi_matched_taxonomic_status_idx ON view_full_occurrence_individual_dev USING btree (matched_taxonomic_status);

CREATE INDEX vfoi_scrubbed_taxon_name_no_author_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_taxon_name_no_author);

CREATE INDEX vfoi_name_matched_idx ON view_full_occurrence_individual_dev USING btree (name_matched);

CREATE INDEX vfoi_scrubbed_author_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_author);

CREATE INDEX vfoi_name_matched_author_idx ON view_full_occurrence_individual_dev USING btree (name_matched_author);
