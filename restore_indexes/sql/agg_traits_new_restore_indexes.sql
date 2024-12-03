-- -----------------------------------------------------------------
-- Restores all indexes on table agg_traits_new,
-- including spatial indexes and constraints
-- 
-- Use this version when updating table agg_traits in live database 
-- by copying to table agg_traits_new
-- 
-- Note that index names contain 'agg_traits_new' instead of 'agg_traits'. 
-- These can be changed to 'agg_traits_new' once the original table and 
-- its indexes have been deleted, or archived in a different schema. 
-- Index names are only unique within schemas.
-- -----------------------------------------------------------------

SET search_path TO :sch;

-- Primary key
ALTER TABLE agg_traits_new ADD PRIMARY KEY (id);

-- Simple indexes
CREATE INDEX agg_traits_new_fk_gnrs_id_idx ON agg_traits_new (fk_gnrs_id);
CREATE INDEX agg_traits_new_country_idx ON agg_traits_new (country);
CREATE INDEX agg_traits_new_country_state_province_idx ON agg_traits_new (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX agg_traits_new_country_state_province_county_idx ON agg_traits_new (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX agg_traits_new_lat_long_not_null_idx ON agg_traits_new (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX agg_traits_new_is_in_country_idx ON agg_traits_new (is_in_country);
CREATE INDEX agg_traits_new_is_in_state_province_idx ON agg_traits_new (is_in_state_province);
CREATE INDEX agg_traits_new_is_in_county_idx ON agg_traits_new (is_in_county);
CREATE INDEX agg_traits_new_is_geovalid_idx ON agg_traits_new (is_geovalid);
CREATE INDEX agg_traits_new_is_new_world_idx ON agg_traits_new (is_new_world);
CREATE INDEX agg_traits_new_visiting_date_idx ON agg_traits_new (visiting_date);
CREATE INDEX agg_traits_new_visiting_date_accuracy_idx ON agg_traits_new (visiting_date_accuracy);
CREATE INDEX agg_traits_new_elevation_m_idx ON agg_traits_new (elevation_m);
CREATE INDEX agg_traits_new_observation_date_idx ON agg_traits_new (observation_date);
CREATE INDEX agg_traits_new_observation_date_accuracy_idx ON agg_traits_new (observation_date_accuracy);
CREATE INDEX agg_traits_new_bien_taxonomy_id_idx ON agg_traits_new (bien_taxonomy_id);
CREATE INDEX agg_traits_new_taxon_id_idx ON agg_traits_new (taxon_id);
CREATE INDEX agg_traits_new_family_taxon_id_idx ON agg_traits_new (family_taxon_id);
CREATE INDEX agg_traits_new_genus_taxon_id_idx ON agg_traits_new (genus_taxon_id);
CREATE INDEX agg_traits_new_species_taxon_id_idx ON agg_traits_new (species_taxon_id);
CREATE INDEX agg_traits_new_verbatim_scientific_name_idx ON agg_traits_new (verbatim_scientific_name);
CREATE INDEX agg_traits_new_fk_tnrs_id_idx ON agg_traits_new (fk_tnrs_id);
CREATE INDEX agg_traits_new_family_matched_idx ON agg_traits_new (family_matched);
CREATE INDEX agg_traits_new_name_matched_idx ON agg_traits_new (name_matched);
CREATE INDEX agg_traits_new_matched_taxonomic_status_idx ON agg_traits_new (matched_taxonomic_status);
CREATE INDEX agg_traits_new_match_summary_idx ON agg_traits_new (match_summary);
CREATE INDEX agg_traits_new_scrubbed_taxonomic_status_idx ON agg_traits_new (scrubbed_taxonomic_status);
CREATE INDEX agg_traits_new_higher_plant_group_idx ON agg_traits_new (higher_plant_group);
CREATE INDEX agg_traits_new_scrubbed_family_idx ON agg_traits_new (scrubbed_family);
CREATE INDEX agg_traits_new_scrubbed_genus_idx ON agg_traits_new (scrubbed_genus);
CREATE INDEX agg_traits_new_scrubbed_species_binomial_idx ON agg_traits_new (scrubbed_species_binomial);
CREATE INDEX agg_traits_new_scrubbed_taxon_name_no_author_idx ON agg_traits_new (scrubbed_taxon_name_no_author);
CREATE INDEX agg_traits_new_scrubbed_species_binomial_with_morphospecies_idx ON agg_traits_new (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX agg_traits_new_is_embargoed_observation_idx ON agg_traits_new (is_embargoed_observation);
CREATE INDEX agg_traits_new_nsr_id_idx ON agg_traits_new (nsr_id);
CREATE INDEX agg_traits_new_native_status_idx ON agg_traits_new (native_status);
CREATE INDEX agg_traits_new_is_introduced_idx ON agg_traits_new (is_introduced);
CREATE INDEX agg_traits_new_is_cultivated_in_region_idx ON agg_traits_new (is_cultivated_in_region);
CREATE INDEX agg_traits_new_is_cultivated_taxon_idx ON agg_traits_new (is_cultivated_taxon);
CREATE INDEX agg_traits_new_is_cultivated_observation_idx ON agg_traits_new (is_cultivated_observation);
CREATE INDEX agg_traits_new_authorship_idx ON agg_traits_new USING btree (authorship);
CREATE INDEX agg_traits_new_method_idx ON agg_traits_new USING btree (method);
CREATE INDEX agg_traits_new_project_pi_idx ON agg_traits_new USING btree (project_pi);
CREATE INDEX agg_traits_new_region_idx ON agg_traits_new USING btree (region);
CREATE INDEX agg_traits_new_source_idx ON agg_traits_new USING btree (source);
CREATE INDEX agg_traits_new_trait_name_idx ON agg_traits_new USING btree (trait_name);
CREATE INDEX agg_traits_new_unit_idx ON agg_traits_new USING btree (unit);
CREATE INDEX agg_traits_new_is_experiment_idx ON agg_traits_new (is_experiment);
CREATE INDEX agg_traits_new_is_individual_trait_idx ON agg_traits_new (is_individual_trait);
CREATE INDEX agg_traits_new_is_species_trait_idx ON agg_traits_new (is_species_trait);
CREATE INDEX agg_traits_new_is_trait_value_valid_idx ON agg_traits_new (is_trait_value_valid);
CREATE INDEX agg_traits_new_taxonobservation_id_idx ON agg_traits_new (taxonobservation_id);
CREATE INDEX agg_traits_new_is_individual_measurement_idx ON agg_traits_new (is_individual_measurement);


CREATE INDEX agg_traits_new_gid_0_idx ON agg_traits_new (gid_0);
CREATE INDEX agg_traits_new_gid_1_idx ON agg_traits_new (gid_1);
CREATE INDEX agg_traits_new_gid_2_idx ON agg_traits_new (gid_2);
CREATE INDEX agg_traits_new_fk_cds_id_idx ON agg_traits_new (fk_cds_id);
CREATE INDEX agg_traits_new_is_centroid_idx ON agg_traits_new (is_centroid);
CREATE INDEX agg_traits_new_centroid_type_idx ON agg_traits_new (centroid_type);
CREATE INDEX agg_traits_new_is_invalid_latlong_idx ON agg_traits_new (is_invalid_latlong);
CREATE INDEX agg_traits_new_cods_proximity_id_idx ON agg_traits_new (cods_proximity_id);
CREATE INDEX agg_traits_new_cods_keyword_id_idx ON agg_traits_new (cods_keyword_id);

-- Compound indexes for frequent queries
