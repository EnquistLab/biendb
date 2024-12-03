--
-- Restores all indexes on analytical_stem_new
--

-- -----------------------------------------------------------------
-- Restores all indexes on table analytical_stem_new,
-- including spatial indexes and constraints
-- 
-- Use this version when updating analytical_stem in live database by copying to 
-- table analytical_stem_new.
-- Note that index names contain 'analytical_stem_new' instead of 'analytical_stem'. 
-- These can be changed back to 'analytical_stem' once the original table and its 
-- indexes have been deleted, or archived in a different schema. Index names
-- are only unique within schemas.
-- -----------------------------------------------------------------

SET search_path TO :sch;

-- Create primary key
ALTER TABLE  analytical_stem_new ADD PRIMARY KEY (analytical_stem_id);

-- Simple indexes
CREATE INDEX analytical_stem_new_taxonobservation_id_idx ON analytical_stem_new (taxonobservation_id);
CREATE INDEX analytical_stem_new_plot_metadata_id_idx ON analytical_stem_new (plot_metadata_id);
CREATE INDEX analytical_stem_new_datasource_id_idx ON analytical_stem_new (datasource_id);
CREATE INDEX analytical_stem_new_datasource_idx ON analytical_stem_new (datasource);
CREATE INDEX analytical_stem_new_dataset_idx ON analytical_stem_new (dataset);
CREATE INDEX analytical_stem_new_fk_gnrs_id_idx ON analytical_stem_new (fk_gnrs_id);
CREATE INDEX analytical_stem_new_country_idx ON analytical_stem_new (country);
CREATE INDEX analytical_stem_new_country_state_province_idx ON analytical_stem_new (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX analytical_stem_new_country_state_province_county_idx ON analytical_stem_new (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX analytical_stem_new_lat_long_not_null_idx ON analytical_stem_new (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX analytical_stem_new_is_in_country_idx ON analytical_stem_new (is_in_country);
CREATE INDEX analytical_stem_new_is_in_state_province_idx ON analytical_stem_new (is_in_state_province);
CREATE INDEX analytical_stem_new_is_in_county_idx ON analytical_stem_new (is_in_county);
CREATE INDEX analytical_stem_new_is_geovalid_idx ON analytical_stem_new (is_geovalid);
CREATE INDEX analytical_stem_new_is_new_world_idx ON analytical_stem_new (is_new_world);
CREATE INDEX analytical_stem_new_plot_name_idx ON analytical_stem_new (plot_name);
CREATE INDEX analytical_stem_new_plot_name_subplot_idx ON analytical_stem_new (plot_name,subplot);
CREATE INDEX analytical_stem_new_event_date_idx ON analytical_stem_new (event_date);
CREATE INDEX analytical_stem_new_event_date_accuracy_idx ON analytical_stem_new (event_date_accuracy);
CREATE INDEX analytical_stem_new_elevation_m_idx ON analytical_stem_new (elevation_m);
CREATE INDEX analytical_stem_new_plot_area_ha_idx ON analytical_stem_new (plot_area_ha);
CREATE INDEX analytical_stem_new_sampling_protocol_idx ON analytical_stem_new (sampling_protocol);
CREATE INDEX analytical_stem_new_vegetation_verbatim_idx ON analytical_stem_new (vegetation_verbatim);
CREATE INDEX analytical_stem_new_community_concept_name_idx ON analytical_stem_new (community_concept_name);
CREATE INDEX analytical_stem_new_date_collected_idx ON analytical_stem_new (date_collected);
CREATE INDEX analytical_stem_new_date_collected_accuracy_idx ON analytical_stem_new (date_collected_accuracy);
CREATE INDEX analytical_stem_new_bien_taxonomy_id_idx ON analytical_stem_new (bien_taxonomy_id);
CREATE INDEX analytical_stem_new_taxon_id_idx ON analytical_stem_new (taxon_id);
CREATE INDEX analytical_stem_new_family_taxon_id_idx ON analytical_stem_new (family_taxon_id);
CREATE INDEX analytical_stem_new_genus_taxon_id_idx ON analytical_stem_new (genus_taxon_id);
CREATE INDEX analytical_stem_new_species_taxon_id_idx ON analytical_stem_new (species_taxon_id);
CREATE INDEX analytical_stem_new_fk_tnrs_id_idx ON analytical_stem_new (fk_tnrs_id);
CREATE INDEX analytical_stem_new_family_matched_idx ON analytical_stem_new (family_matched);
CREATE INDEX analytical_stem_new_name_matched_idx ON analytical_stem_new (name_matched);
CREATE INDEX analytical_stem_new_matched_taxonomic_status_idx ON analytical_stem_new (matched_taxonomic_status);
CREATE INDEX analytical_stem_new_match_summary_idx ON analytical_stem_new (match_summary);
CREATE INDEX analytical_stem_new_scrubbed_taxonomic_status_idx ON analytical_stem_new (scrubbed_taxonomic_status);
CREATE INDEX analytical_stem_new_higher_plant_group_idx ON analytical_stem_new (higher_plant_group);
CREATE INDEX analytical_stem_new_scrubbed_family_idx ON analytical_stem_new (scrubbed_family);
CREATE INDEX analytical_stem_new_scrubbed_genus_idx ON analytical_stem_new (scrubbed_genus);
CREATE INDEX analytical_stem_new_scrubbed_species_binomial_idx ON analytical_stem_new (scrubbed_species_binomial);
CREATE INDEX analytical_stem_new_scrubbed_taxon_name_no_author_idx ON analytical_stem_new (scrubbed_taxon_name_no_author);
CREATE INDEX analytical_stem_new_scrubbed_species_binomial_with_morphospecies_idx ON analytical_stem_new (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX analytical_stem_new_growth_form_idx ON analytical_stem_new (growth_form);
CREATE INDEX analytical_stem_new_individual_id_idx ON analytical_stem_new (individual_id);
CREATE INDEX analytical_stem_new_is_embargoed_observation_idx ON analytical_stem_new (is_embargoed_observation);
CREATE INDEX analytical_stem_new_nsr_id_idx ON analytical_stem_new (nsr_id);
CREATE INDEX analytical_stem_new_native_status_idx ON analytical_stem_new (native_status);
CREATE INDEX analytical_stem_new_is_introduced_idx ON analytical_stem_new (is_introduced);
CREATE INDEX analytical_stem_new_is_cultivated_in_region_idx ON analytical_stem_new (is_cultivated_in_region);
CREATE INDEX analytical_stem_new_is_cultivated_taxon_idx ON analytical_stem_new (is_cultivated_taxon);
CREATE INDEX analytical_stem_new_is_cultivated_observation_idx ON analytical_stem_new (is_cultivated_observation);

CREATE INDEX analytical_stem_new_gid_0_idx ON analytical_stem_new (gid_0);
CREATE INDEX analytical_stem_new_gid_1_idx ON analytical_stem_new (gid_1);
CREATE INDEX analytical_stem_new_gid_2_idx ON analytical_stem_new (gid_2);
CREATE INDEX analytical_stem_new_fk_cds_id_idx ON analytical_stem_new (fk_cds_id);
CREATE INDEX analytical_stem_new_is_centroid_idx ON analytical_stem_new (is_centroid);
CREATE INDEX analytical_stem_new_centroid_type_idx ON analytical_stem_new (centroid_type);
CREATE INDEX analytical_stem_new_is_invalid_latlong_idx ON analytical_stem_new (is_invalid_latlong);
CREATE INDEX analytical_stem_new_cods_proximity_id_idx ON analytical_stem_new (cods_proximity_id);
CREATE INDEX analytical_stem_new_cods_keyword_id_idx ON analytical_stem_new (cods_keyword_id);
CREATE INDEX analytical_stem_new_latlong_verbatim_idx ON analytical_stem_new (latlong_verbatim);


-- Compound indexes for frequent queries
-- REVISE THIS INDEX AFTER SCHEMA UPDATE! Last line should read:
-- AND (is_introduced=0 OR is_introduced IS NULL)
CREATE INDEX analytical_stem_new_validated_species_idx ON analytical_stem_new USING btree (scrubbed_species_binomial) 
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND higher_plant_group IS NOT NULL
AND (is_geovalid = 1 OR is_geovalid IS NULL)
AND (latitude IS NOT NULL AND longitude IS NOT NULL)
AND (is_introduced=0 OR is_introduced IS NULL)
;

