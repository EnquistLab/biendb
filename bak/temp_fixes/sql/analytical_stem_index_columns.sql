-- ---------------------------------------------------------
-- Index columns needed for joins
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

CREATE UNIQUE INDEX vfoi_pkey ON view_full_occurrence_individual USING btree (taxonobservation_id);

CREATE INDEX analytical_stem_taxonobservation_id_fkey_idx ON analytical_stem USING btree (taxonobservation_id);
