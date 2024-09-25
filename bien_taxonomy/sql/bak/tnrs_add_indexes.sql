-- -------------------------------------------------------------
-- Add remaining indexes to table tnrs
-- -------------------------------------------------------------

SET search_path TO :dev_schema;

CREATE INDEX tnrs_scrubbed_taxonomic_status_idx ON tnrs USING btree (scrubbed_taxonomic_status);
CREATE INDEX tnrs_scrubbed_taxon_name_no_author_idx ON tnrs USING btree (scrubbed_taxon_name_no_author);
CREATE INDEX tnrs_scrubbed_author_idx ON tnrs USING btree (scrubbed_author);

