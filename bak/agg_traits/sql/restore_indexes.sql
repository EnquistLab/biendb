-- -------------------------------------------------------------
-- Generate indexes present in original table 
-- -------------------------------------------------------------

set search_path to :dev_schema;

CREATE INDEX ON agg_traits USING btree (verbatim_family);
CREATE INDEX ON agg_traits USING btree (verbatim_scientific_name);
CREATE INDEX ON agg_traits USING btree (family_matched);
CREATE INDEX ON agg_traits USING btree (name_matched);
CREATE INDEX ON agg_traits USING btree (higher_plant_group);
CREATE INDEX ON agg_traits USING btree (matched_taxonomic_status);
CREATE INDEX ON agg_traits USING btree (scrubbed_taxonomic_status);
CREATE INDEX ON agg_traits USING btree (scrubbed_family);
CREATE INDEX ON agg_traits USING btree (scrubbed_genus);
CREATE INDEX ON agg_traits USING btree (scrubbed_species_binomial);
CREATE INDEX ON agg_traits USING btree (scrubbed_taxon_name_no_author);
CREATE INDEX ON agg_traits USING btree (scrubbed_taxon_canonical);
CREATE INDEX ON agg_traits USING btree (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX ON agg_traits USING btree (trait_name);
CREATE INDEX ON agg_traits USING btree (unit);
CREATE INDEX ON agg_traits USING btree ("method");
CREATE INDEX ON agg_traits USING btree (region);
CREATE INDEX ON agg_traits USING btree (country);
CREATE INDEX ON agg_traits USING btree (stateprovince);
CREATE INDEX ON agg_traits USING btree ("source");
CREATE INDEX ON agg_traits USING btree (project_pi);
CREATE INDEX ON agg_traits USING btree (authorship);