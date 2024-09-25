--
-- Add remaining indexes to plot_metadata
-- 

SET search_path TO :dev_schema;

CREATE INDEX plot_metadata_country_idx
ON plot_metadata USING btree (country);
CREATE INDEX plot_metadata_state_province_idx
ON plot_metadata USING btree (country, state_province)
WHERE state_province IS NOT NULL;
CREATE INDEX plot_metadata_county_idx
ON plot_metadata USING btree (country, state_province, county) 
WHERE county IS NOT NULL;
CREATE INDEX plot_metadata_is_geovalid_idx
ON plot_metadata USING btree (is_geovalid);
CREATE INDEX plot_metadata_is_new_world_idx
ON plot_metadata USING btree (is_new_world);
CREATE INDEX plot_metadata_community_concept_name_idx
ON plot_metadata USING btree (community_concept_name);

CREATE INDEX plot_metadata_dataowner_idx ON plot_metadata USING btree (dataowner);
CREATE INDEX plot_metadata_plot_area_ha_idx ON plot_metadata USING btree (plot_area_ha);
CREATE INDEX plot_metadata_sampling_protocol_idx ON plot_metadata USING btree (sampling_protocol);
CREATE INDEX plot_metadata_abundance_measurement_idx ON plot_metadata USING btree (abundance_measurement);
CREATE INDEX plot_metadata_has_strata_idx ON plot_metadata USING btree (has_strata);
CREATE INDEX plot_metadata_has_stem_data_idx ON plot_metadata USING btree (has_stem_data);
CREATE INDEX plot_metadata_stem_diam_min_idx ON plot_metadata USING btree (stem_diam_min);
CREATE INDEX plot_metadata_stem_diam_max_idx ON plot_metadata USING btree (stem_diam_max);
CREATE INDEX plot_metadata_stem_measurement_height_idx ON plot_metadata USING btree (stem_measurement_height);
CREATE INDEX plot_metadata_growth_forms_included_all_idx ON plot_metadata USING btree (growth_forms_included_all);
CREATE INDEX plot_metadata_growth_forms_included_trees_idx ON plot_metadata USING btree (growth_forms_included_trees);
CREATE INDEX plot_metadata_growth_forms_included_shrubs_idx ON plot_metadata USING btree (growth_forms_included_shrubs);
CREATE INDEX plot_metadata_growth_forms_included_lianas_idx ON plot_metadata USING btree (growth_forms_included_lianas);
CREATE INDEX plot_metadata_growth_forms_included_herbs_idx ON plot_metadata USING btree (growth_forms_included_herbs);
CREATE INDEX plot_metadata_growth_forms_included_epiphytes_idx ON plot_metadata USING btree (growth_forms_included_epiphytes);
CREATE INDEX plot_metadata_taxa_included_all_idx ON plot_metadata USING btree (taxa_included_all);
CREATE INDEX plot_metadata_taxa_included_seed_plants_idx ON plot_metadata USING btree (taxa_included_seed_plants);
CREATE INDEX plot_metadata_taxa_included_ferns_lycophytes_idx ON plot_metadata USING btree (taxa_included_ferns_lycophytes);
CREATE INDEX plot_metadata_taxa_included_bryophytes_idx ON plot_metadata USING btree (taxa_included_bryophytes);
CREATE INDEX plot_metadata_taxa_included_exclusions_idx ON plot_metadata USING btree (taxa_included_exclusions);
