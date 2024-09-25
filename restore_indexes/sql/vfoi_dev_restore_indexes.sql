-- --------------------------------------------------------------------
-- Restores all indexes on development version of vfoi
-- Including spatial indexes
-- --------------------------------------------------------------------

SET search_path TO :sch, postgis;

-- Create primary key
ALTER TABLE view_full_occurrence_individual_dev ADD PRIMARY KEY (taxonobservation_id);

-- Simple indexes
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual_dev (observation_type);
CREATE INDEX vfoi_plot_metadata_id_idx ON view_full_occurrence_individual_dev (plot_metadata_id);
CREATE INDEX vfoi_datasource_id_idx ON view_full_occurrence_individual_dev (datasource_id);
CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev (datasource);
CREATE INDEX vfoi_dataset_idx ON view_full_occurrence_individual_dev (dataset);
CREATE INDEX vfoi_fk_gnrs_id_idx ON view_full_occurrence_individual_dev (fk_gnrs_id);
CREATE INDEX vfoi_country_idx ON view_full_occurrence_individual_dev (country);
CREATE INDEX vfoi_country_state_province_idx ON view_full_occurrence_individual_dev (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX vfoi_country_state_province_county_idx ON view_full_occurrence_individual_dev (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX vfoi_lat_long_not_null_idx ON view_full_occurrence_individual_dev (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX vfoi_is_in_country_idx ON view_full_occurrence_individual_dev (is_in_country);
CREATE INDEX vfoi_is_in_state_province_idx ON view_full_occurrence_individual_dev (is_in_state_province);
CREATE INDEX vfoi_is_in_county_idx ON view_full_occurrence_individual_dev (is_in_county);
CREATE INDEX vfoi_is_geovalid_idx ON view_full_occurrence_individual_dev (is_geovalid);
CREATE INDEX vfoi_is_new_world_idx ON view_full_occurrence_individual_dev (is_new_world);
CREATE INDEX vfoi_plot_name_idx ON view_full_occurrence_individual_dev (plot_name);
CREATE INDEX vfoi_plot_name_subplot_idx ON view_full_occurrence_individual_dev (plot_name,subplot);
CREATE INDEX vfoi_event_date_idx ON view_full_occurrence_individual_dev (event_date);
CREATE INDEX vfoi_event_date_accuracy_idx ON view_full_occurrence_individual_dev (event_date_accuracy);
CREATE INDEX vfoi_elevation_m_idx ON view_full_occurrence_individual_dev (elevation_m);
CREATE INDEX vfoi_plot_area_ha_idx ON view_full_occurrence_individual_dev (plot_area_ha);
CREATE INDEX vfoi_sampling_protocol_idx ON view_full_occurrence_individual_dev (sampling_protocol);
CREATE INDEX vfoi_catalog_number_idx ON view_full_occurrence_individual_dev (catalog_number);
CREATE INDEX vfoi_date_collected_idx ON view_full_occurrence_individual_dev (date_collected);
CREATE INDEX vfoi_date_collected_accuracy_idx ON view_full_occurrence_individual_dev (date_collected_accuracy);
CREATE INDEX vfoi_bien_taxonomy_id_idx ON view_full_occurrence_individual_dev (bien_taxonomy_id);
CREATE INDEX vfoi_taxon_id_idx ON view_full_occurrence_individual_dev (taxon_id);
CREATE INDEX vfoi_family_taxon_id_idx ON view_full_occurrence_individual_dev (family_taxon_id);
CREATE INDEX vfoi_genus_taxon_id_idx ON view_full_occurrence_individual_dev (genus_taxon_id);
CREATE INDEX vfoi_species_taxon_id_idx ON view_full_occurrence_individual_dev (species_taxon_id);
CREATE INDEX vfoi_verbatim_scientific_name_idx ON view_full_occurrence_individual_dev (verbatim_scientific_name);
CREATE INDEX vfoi_fk_tnrs_id_idx ON view_full_occurrence_individual_dev (fk_tnrs_id);
CREATE INDEX vfoi_family_matched_idx ON view_full_occurrence_individual_dev (family_matched);
CREATE INDEX vfoi_name_matched_idx ON view_full_occurrence_individual_dev (name_matched);
CREATE INDEX vfoi_matched_taxonomic_status_idx ON view_full_occurrence_individual_dev (matched_taxonomic_status);
CREATE INDEX vfoi_match_summary_idx ON view_full_occurrence_individual_dev (match_summary);
CREATE INDEX vfoi_scrubbed_taxonomic_status_idx ON view_full_occurrence_individual_dev (scrubbed_taxonomic_status);
CREATE INDEX vfoi_higher_plant_group_idx ON view_full_occurrence_individual_dev (higher_plant_group);
CREATE INDEX vfoi_scrubbed_family_idx ON view_full_occurrence_individual_dev (scrubbed_family);
CREATE INDEX vfoi_scrubbed_genus_idx ON view_full_occurrence_individual_dev (scrubbed_genus);
CREATE INDEX vfoi_scrubbed_species_binomial_idx ON view_full_occurrence_individual_dev (scrubbed_species_binomial);
CREATE INDEX vfoi_scrubbed_taxon_name_no_author_idx ON view_full_occurrence_individual_dev (scrubbed_taxon_name_no_author);
CREATE INDEX vfoi_scrubbed_species_binomial_with_morphospecies_idx ON view_full_occurrence_individual_dev (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX vfoi_growth_form_idx ON view_full_occurrence_individual_dev (growth_form);
CREATE INDEX vfoi_cites_idx ON view_full_occurrence_individual_dev (cites);
CREATE INDEX vfoi_iucn_idx ON view_full_occurrence_individual_dev (iucn);
CREATE INDEX vfoi_usda_federal_idx ON view_full_occurrence_individual_dev (usda_federal);
CREATE INDEX vfoi_usda_state_idx ON view_full_occurrence_individual_dev (usda_state);
CREATE INDEX vfoi_is_embargoed_observation_idx ON view_full_occurrence_individual_dev (is_embargoed_observation);
CREATE INDEX vfoi_nsr_id_idx ON view_full_occurrence_individual_dev (nsr_id);
CREATE INDEX vfoi_native_status_idx ON view_full_occurrence_individual_dev (native_status);
CREATE INDEX vfoi_is_introduced_idx ON view_full_occurrence_individual_dev (is_introduced);
CREATE INDEX vfoi_is_cultivated_in_region_idx ON view_full_occurrence_individual_dev (is_cultivated_in_region);
CREATE INDEX vfoi_is_cultivated_taxon_idx ON view_full_occurrence_individual_dev (is_cultivated_taxon);
CREATE INDEX vfoi_is_cultivated_observation_idx ON view_full_occurrence_individual_dev (is_cultivated_observation);
CREATE INDEX vfoi_geom_not_null_idx ON
view_full_occurrence_individual_dev(is_geovalid)
WHERE geom IS NOT NULL; -- indexed column not important
CREATE INDEX vfoi_georef_protocol_idx ON view_full_occurrence_individual_dev (georef_protocol);
CREATE INDEX vfoi_is_location_cultivated_idx ON view_full_occurrence_individual_dev (is_location_cultivated);

CREATE INDEX vfoi_gid_0_idx ON view_full_occurrence_individual_dev (gid_0);
CREATE INDEX vfoi_gid_1_idx ON view_full_occurrence_individual_dev (gid_1);
CREATE INDEX vfoi_gid_2_idx ON view_full_occurrence_individual_dev (gid_2);
CREATE INDEX vfoi_fk_cds_id_idx ON view_full_occurrence_individual_dev (fk_cds_id);
CREATE INDEX vfoi_is_centroid_idx ON view_full_occurrence_individual_dev (is_centroid);
CREATE INDEX vfoi_centroid_type_idx ON view_full_occurrence_individual_dev (centroid_type);
CREATE INDEX vfoi_is_invalid_latlong_idx ON view_full_occurrence_individual_dev (is_invalid_latlong);
CREATE INDEX vfoi_cods_proximity_id_idx ON view_full_occurrence_individual_dev (cods_proximity_id);
CREATE INDEX vfoi_cods_keyword_id_idx ON view_full_occurrence_individual_dev (cods_keyword_id);
CREATE INDEX vfoi_latlong_verbatim_idx ON view_full_occurrence_individual_dev (latlong_verbatim);


-- Default BIEN range modelling index
-- Covering partial index
CREATE INDEX vfoi_bien_range_model_default_idx ON view_full_occurrence_individual_dev (
taxonobservation_id, 
datasource_id, datasource, dataset, dataowner, plot_metadata_id,
country, state_province, county, is_new_world, 
latitude, longitude, event_date,
custodial_institution_codes, catalog_number, collection_code, 
recorded_by, record_number, date_collected, 
taxon_id, name_submitted, name_matched, tnrs_name_matched_score, 
matched_taxonomic_status, scrubbed_taxonomic_status, 
scrubbed_family, scrubbed_genus, scrubbed_species_binomial, 
scrubbed_species_binomial_with_morphospecies,
scrubbed_taxon_name_no_author, scrubbed_author,
is_embargoed_observation
)
WHERE scrubbed_species_binomial IS NOT NULL
AND observation_type IN ('plot','specimen','literature','checklist')
AND is_geovalid = 1
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND (is_centroid IS NULL OR is_centroid=0)
AND is_location_cultivated IS NULL
AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)')
AND (is_introduced=0 OR is_introduced IS NULL)
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
;

-- 
-- Spatial indexes and constraints
-- 

DROP INDEX IF EXISTS vfoi_georeferenced_species_idx;
CREATE INDEX vfoi_georeferenced_species_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

-- Main (gist) index on geometry column
DROP INDEX IF EXISTS vfoi_gist_idx;
CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual_dev USING gist (geom);

-- Geometry dimensions must be 2 (point)
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) is 4326 (WGS84)
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_srid_geom
   CHECK (ST_SRID(geom) = 4326);
   





