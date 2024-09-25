--
-- Restores all indexes on agg_traits
--

SET search_path TO :sch;

-- Primary key
ALTER TABLE agg_traits ADD PRIMARY KEY (id);

-- Simple indexes
CREATE INDEX agg_traits_fk_gnrs_id_idx ON agg_traits (fk_gnrs_id);
CREATE INDEX agg_traits_country_idx ON agg_traits (country);
CREATE INDEX agg_traits_country_state_province_idx ON agg_traits (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX agg_traits_country_state_province_county_idx ON agg_traits (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX agg_traits_lat_long_not_null_idx ON agg_traits (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX agg_traits_is_in_country_idx ON agg_traits (is_in_country);
CREATE INDEX agg_traits_is_in_state_province_idx ON agg_traits (is_in_state_province);
CREATE INDEX agg_traits_is_in_county_idx ON agg_traits (is_in_county);
CREATE INDEX agg_traits_is_geovalid_idx ON agg_traits (is_geovalid);
CREATE INDEX agg_traits_is_new_world_idx ON agg_traits (is_new_world);
CREATE INDEX agg_traits_visiting_date_idx ON agg_traits (visiting_date);
CREATE INDEX agg_traits_visiting_date_accuracy_idx ON agg_traits (visiting_date_accuracy);
CREATE INDEX agg_traits_elevation_m_idx ON agg_traits (elevation_m);
CREATE INDEX agg_traits_observation_date_idx ON agg_traits (observation_date);
CREATE INDEX agg_traits_observation_date_accuracy_idx ON agg_traits (observation_date_accuracy);
CREATE INDEX agg_traits_bien_taxonomy_id_idx ON agg_traits (bien_taxonomy_id);
CREATE INDEX agg_traits_taxon_id_idx ON agg_traits (taxon_id);
CREATE INDEX agg_traits_family_taxon_id_idx ON agg_traits (family_taxon_id);
CREATE INDEX agg_traits_genus_taxon_id_idx ON agg_traits (genus_taxon_id);
CREATE INDEX agg_traits_species_taxon_id_idx ON agg_traits (species_taxon_id);
CREATE INDEX agg_traits_verbatim_scientific_name_idx ON agg_traits (verbatim_scientific_name);
CREATE INDEX agg_traits_fk_tnrs_id_idx ON agg_traits (fk_tnrs_id);
CREATE INDEX agg_traits_family_matched_idx ON agg_traits (family_matched);
CREATE INDEX agg_traits_name_matched_idx ON agg_traits (name_matched);
CREATE INDEX agg_traits_matched_taxonomic_status_idx ON agg_traits (matched_taxonomic_status);
CREATE INDEX agg_traits_match_summary_idx ON agg_traits (match_summary);
CREATE INDEX agg_traits_scrubbed_taxonomic_status_idx ON agg_traits (scrubbed_taxonomic_status);
CREATE INDEX agg_traits_higher_plant_group_idx ON agg_traits (higher_plant_group);
CREATE INDEX agg_traits_scrubbed_family_idx ON agg_traits (scrubbed_family);
CREATE INDEX agg_traits_scrubbed_genus_idx ON agg_traits (scrubbed_genus);
CREATE INDEX agg_traits_scrubbed_species_binomial_idx ON agg_traits (scrubbed_species_binomial);
CREATE INDEX agg_traits_scrubbed_taxon_name_no_author_idx ON agg_traits (scrubbed_taxon_name_no_author);
CREATE INDEX agg_traits_scrubbed_species_binomial_with_morphospecies_idx ON agg_traits (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX agg_traits_is_embargoed_observation_idx ON agg_traits (is_embargoed_observation);
CREATE INDEX agg_traits_nsr_id_idx ON agg_traits (nsr_id);
CREATE INDEX agg_traits_native_status_idx ON agg_traits (native_status);
CREATE INDEX agg_traits_is_introduced_idx ON agg_traits (is_introduced);
CREATE INDEX agg_traits_is_cultivated_in_region_idx ON agg_traits (is_cultivated_in_region);
CREATE INDEX agg_traits_is_cultivated_taxon_idx ON agg_traits (is_cultivated_taxon);
CREATE INDEX agg_traits_is_cultivated_observation_idx ON agg_traits (is_cultivated_observation);
CREATE INDEX agg_traits_authorship_idx ON agg_traits USING btree (authorship);
CREATE INDEX agg_traits_method_idx ON agg_traits USING btree (method);
CREATE INDEX agg_traits_project_pi_idx ON agg_traits USING btree (project_pi);
CREATE INDEX agg_traits_region_idx ON agg_traits USING btree (region);
CREATE INDEX agg_traits_source_idx ON agg_traits USING btree (source);
CREATE INDEX agg_traits_trait_name_idx ON agg_traits USING btree (trait_name);
CREATE INDEX agg_traits_unit_idx ON agg_traits USING btree (unit);
CREATE INDEX agg_traits_is_experiment_idx ON agg_traits (is_experiment);
CREATE INDEX agg_traits_is_individual_trait_idx ON agg_traits (is_individual_trait);
CREATE INDEX agg_traits_is_species_trait_idx ON agg_traits (is_species_trait);
CREATE INDEX agg_traits_is_trait_value_valid_idx ON agg_traits (is_trait_value_valid);
CREATE INDEX agg_traits_taxonobservation_id_idx ON agg_traits (taxonobservation_id);
CREATE INDEX agg_traits_is_individual_measurement_idx ON agg_traits (is_individual_measurement);


CREATE INDEX agg_traits_gid_0_idx ON agg_traits (gid_0);
CREATE INDEX agg_traits_gid_1_idx ON agg_traits (gid_1);
CREATE INDEX agg_traits_gid_2_idx ON agg_traits (gid_2);
CREATE INDEX agg_traits_fk_cds_id_idx ON agg_traits (fk_cds_id);
CREATE INDEX agg_traits_is_centroid_idx ON agg_traits (is_centroid);
CREATE INDEX agg_traits_centroid_type_idx ON agg_traits (centroid_type);
CREATE INDEX agg_traits_is_invalid_latlong_idx ON agg_traits (is_invalid_latlong);
CREATE INDEX agg_traits_cods_proximity_id_idx ON agg_traits (cods_proximity_id);
CREATE INDEX agg_traits_cods_keyword_id_idx ON agg_traits (cods_keyword_id);

-- Compound indexes for frequent queries
