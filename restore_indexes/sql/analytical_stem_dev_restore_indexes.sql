--
-- Restores all indexes on analytical_stem_dev
--

SET search_path TO :sch;

-- Create primary key
ALTER TABLE  analytical_stem_dev ADD PRIMARY KEY (analytical_stem_id);

-- Simple indexes
CREATE INDEX analytical_stem_taxonobservation_id_idx ON analytical_stem_dev (taxonobservation_id);
CREATE INDEX analytical_stem_plot_metadata_id_idx ON analytical_stem_dev (plot_metadata_id);
CREATE INDEX analytical_stem_datasource_id_idx ON analytical_stem_dev (datasource_id);
CREATE INDEX analytical_stem_datasource_idx ON analytical_stem_dev (datasource);
CREATE INDEX analytical_stem_dataset_idx ON analytical_stem_dev (dataset);
CREATE INDEX analytical_stem_fk_gnrs_id_idx ON analytical_stem_dev (fk_gnrs_id);
CREATE INDEX analytical_stem_country_idx ON analytical_stem_dev (country);
CREATE INDEX analytical_stem_country_state_province_idx ON analytical_stem_dev (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX analytical_stem_country_state_province_county_idx ON analytical_stem_dev (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX analytical_stem_lat_long_not_null_idx ON analytical_stem_dev (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX analytical_stem_is_in_country_idx ON analytical_stem_dev (is_in_country);
CREATE INDEX analytical_stem_is_in_state_province_idx ON analytical_stem_dev (is_in_state_province);
CREATE INDEX analytical_stem_is_in_county_idx ON analytical_stem_dev (is_in_county);
CREATE INDEX analytical_stem_is_geovalid_idx ON analytical_stem_dev (is_geovalid);
CREATE INDEX analytical_stem_is_new_world_idx ON analytical_stem_dev (is_new_world);
CREATE INDEX analytical_stem_plot_name_idx ON analytical_stem_dev (plot_name);
CREATE INDEX analytical_stem_plot_name_subplot_idx ON analytical_stem_dev (plot_name,subplot);
CREATE INDEX analytical_stem_event_date_idx ON analytical_stem_dev (event_date);
CREATE INDEX analytical_stem_event_date_accuracy_idx ON analytical_stem_dev (event_date_accuracy);
CREATE INDEX analytical_stem_elevation_m_idx ON analytical_stem_dev (elevation_m);
CREATE INDEX analytical_stem_plot_area_ha_idx ON analytical_stem_dev (plot_area_ha);
CREATE INDEX analytical_stem_sampling_protocol_idx ON analytical_stem_dev (sampling_protocol);
CREATE INDEX analytical_stem_vegetation_verbatim_idx ON analytical_stem_dev (vegetation_verbatim);
CREATE INDEX analytical_stem_community_concept_name_idx ON analytical_stem_dev (community_concept_name);
CREATE INDEX analytical_stem_date_collected_idx ON analytical_stem_dev (date_collected);
CREATE INDEX analytical_stem_date_collected_accuracy_idx ON analytical_stem_dev (date_collected_accuracy);
CREATE INDEX analytical_stem_bien_taxonomy_id_idx ON analytical_stem_dev (bien_taxonomy_id);
CREATE INDEX analytical_stem_taxon_id_idx ON analytical_stem_dev (taxon_id);
CREATE INDEX analytical_stem_family_taxon_id_idx ON analytical_stem_dev (family_taxon_id);
CREATE INDEX analytical_stem_genus_taxon_id_idx ON analytical_stem_dev (genus_taxon_id);
CREATE INDEX analytical_stem_species_taxon_id_idx ON analytical_stem_dev (species_taxon_id);
CREATE INDEX analytical_stem_fk_tnrs_id_idx ON analytical_stem_dev (fk_tnrs_id);
CREATE INDEX analytical_stem_family_matched_idx ON analytical_stem_dev (family_matched);
CREATE INDEX analytical_stem_name_matched_idx ON analytical_stem_dev (name_matched);
CREATE INDEX analytical_stem_matched_taxonomic_status_idx ON analytical_stem_dev (matched_taxonomic_status);
CREATE INDEX analytical_stem_match_summary_idx ON analytical_stem_dev (match_summary);
CREATE INDEX analytical_stem_scrubbed_taxonomic_status_idx ON analytical_stem_dev (scrubbed_taxonomic_status);
CREATE INDEX analytical_stem_higher_plant_group_idx ON analytical_stem_dev (higher_plant_group);
CREATE INDEX analytical_stem_scrubbed_family_idx ON analytical_stem_dev (scrubbed_family);
CREATE INDEX analytical_stem_scrubbed_genus_idx ON analytical_stem_dev (scrubbed_genus);
CREATE INDEX analytical_stem_scrubbed_species_binomial_idx ON analytical_stem_dev (scrubbed_species_binomial);
CREATE INDEX analytical_stem_scrubbed_taxon_name_no_author_idx ON analytical_stem_dev (scrubbed_taxon_name_no_author);
CREATE INDEX analytical_stem_scrubbed_species_binomial_with_morphospecies_idx ON analytical_stem_dev (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX analytical_stem_growth_form_idx ON analytical_stem_dev (growth_form);
CREATE INDEX analytical_stem_individual_id_idx ON analytical_stem_dev (individual_id);
CREATE INDEX analytical_stem_is_embargoed_observation_idx ON analytical_stem_dev (is_embargoed_observation);
CREATE INDEX analytical_stem_nsr_id_idx ON analytical_stem_dev (nsr_id);
CREATE INDEX analytical_stem_native_status_idx ON analytical_stem_dev (native_status);
CREATE INDEX analytical_stem_is_introduced_idx ON analytical_stem_dev (is_introduced);
CREATE INDEX analytical_stem_is_cultivated_in_region_idx ON analytical_stem_dev (is_cultivated_in_region);
CREATE INDEX analytical_stem_is_cultivated_taxon_idx ON analytical_stem_dev (is_cultivated_taxon);
CREATE INDEX analytical_stem_is_cultivated_observation_idx ON analytical_stem_dev (is_cultivated_observation);


CREATE INDEX analytical_stem_gid_0_idx ON analytical_stem_dev (gid_0);
CREATE INDEX analytical_stem_gid_1_idx ON analytical_stem_dev (gid_1);
CREATE INDEX analytical_stem_gid_2_idx ON analytical_stem_dev (gid_2);
CREATE INDEX analytical_stem_fk_cds_id_idx ON analytical_stem_dev (fk_cds_id);
CREATE INDEX analytical_stem_is_centroid_idx ON analytical_stem_dev (is_centroid);
CREATE INDEX analytical_stem_centroid_type_idx ON analytical_stem_dev (centroid_type);
CREATE INDEX analytical_stem_is_invalid_latlong_idx ON analytical_stem_dev (is_invalid_latlong);
CREATE INDEX analytical_stem_cods_proximity_id_idx ON analytical_stem_dev (cods_proximity_id);
CREATE INDEX analytical_stem_cods_keyword_id_idx ON analytical_stem_dev (cods_keyword_id);
CREATE INDEX analytical_stem_latlong_verbatim_idx ON analytical_stem_dev (latlong_verbatim);


-- Compound indexes for frequent queries
-- REVISE THIS INDEX AFTER SCHEMA UPDATE! Last line should read:
-- AND (is_introduced=0 OR is_introduced IS NULL)
CREATE INDEX analytical_stem_validated_species_idx ON analytical_stem_dev USING btree (scrubbed_species_binomial) 
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND higher_plant_group IS NOT NULL
AND (is_geovalid = 1 OR is_geovalid IS NULL)
AND (latitude IS NOT NULL AND longitude IS NOT NULL)
AND (is_introduced=0 OR is_introduced IS NULL)
;

