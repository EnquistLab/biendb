-- -----------------------------------------------------------------
-- Restores all indexes on table view_full_occurrence_individual_new,
-- including spatial indexes and constraints
-- 
-- Use this version when updating vfoi in live database by copying to 
-- table view_full_occurrence_individual_new
-- Note that index names contain 'vfoi_new' instead of 'vfoi'. These
-- can be changed to 'vfoi' once the original table and its indexes 
-- have been deleted, or archived in a different schema. Index names
-- are only unique within schemas.
-- -----------------------------------------------------------------

SET search_path TO :sch, postgis;

-- Create primary key
ALTER TABLE view_full_occurrence_individual_new ADD PRIMARY KEY (taxonobservation_id);

-- Simple indexes
CREATE INDEX vfoi_new_observation_type_idx ON view_full_occurrence_individual_new (observation_type);
CREATE INDEX vfoi_new_plot_metadata_id_idx ON view_full_occurrence_individual_new (plot_metadata_id);
CREATE INDEX vfoi_new_datasource_id_idx ON view_full_occurrence_individual_new (datasource_id);
CREATE INDEX vfoi_new_datasource_idx ON view_full_occurrence_individual_new (datasource);
CREATE INDEX vfoi_new_dataset_idx ON view_full_occurrence_individual_new (dataset);
CREATE INDEX vfoi_new_fk_gnrs_id_idx ON view_full_occurrence_individual_new (fk_gnrs_id);
CREATE INDEX vfoi_new_country_idx ON view_full_occurrence_individual_new (country);
CREATE INDEX vfoi_new_country_state_province_idx ON view_full_occurrence_individual_new (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX vfoi_new_country_state_province_county_idx ON view_full_occurrence_individual_new (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX vfoi_new_lat_long_not_null_idx ON view_full_occurrence_individual_new (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX vfoi_new_is_in_country_idx ON view_full_occurrence_individual_new (is_in_country);
CREATE INDEX vfoi_new_is_in_state_province_idx ON view_full_occurrence_individual_new (is_in_state_province);
CREATE INDEX vfoi_new_is_in_county_idx ON view_full_occurrence_individual_new (is_in_county);
CREATE INDEX vfoi_new_is_geovalid_idx ON view_full_occurrence_individual_new (is_geovalid);
CREATE INDEX vfoi_new_is_new_world_idx ON view_full_occurrence_individual_new (is_new_world);
CREATE INDEX vfoi_new_plot_name_idx ON view_full_occurrence_individual_new (plot_name);
CREATE INDEX vfoi_new_plot_name_subplot_idx ON view_full_occurrence_individual_new (plot_name,subplot);
CREATE INDEX vfoi_new_event_date_idx ON view_full_occurrence_individual_new (event_date);
CREATE INDEX vfoi_new_event_date_accuracy_idx ON view_full_occurrence_individual_new (event_date_accuracy);
CREATE INDEX vfoi_new_elevation_m_idx ON view_full_occurrence_individual_new (elevation_m);
CREATE INDEX vfoi_new_plot_area_ha_idx ON view_full_occurrence_individual_new (plot_area_ha);
CREATE INDEX vfoi_new_sampling_protocol_idx ON view_full_occurrence_individual_new (sampling_protocol);
CREATE INDEX vfoi_new_catalog_number_idx ON view_full_occurrence_individual_new (catalog_number);
CREATE INDEX vfoi_new_date_collected_idx ON view_full_occurrence_individual_new (date_collected);
CREATE INDEX vfoi_new_date_collected_accuracy_idx ON view_full_occurrence_individual_new (date_collected_accuracy);
CREATE INDEX vfoi_new_bien_taxonomy_id_idx ON view_full_occurrence_individual_new (bien_taxonomy_id);
CREATE INDEX vfoi_new_taxon_id_idx ON view_full_occurrence_individual_new (taxon_id);
CREATE INDEX vfoi_new_family_taxon_id_idx ON view_full_occurrence_individual_new (family_taxon_id);
CREATE INDEX vfoi_new_genus_taxon_id_idx ON view_full_occurrence_individual_new (genus_taxon_id);
CREATE INDEX vfoi_new_species_taxon_id_idx ON view_full_occurrence_individual_new (species_taxon_id);
CREATE INDEX vfoi_new_verbatim_scientific_name_idx ON view_full_occurrence_individual_new (verbatim_scientific_name);
CREATE INDEX vfoi_new_fk_tnrs_id_idx ON view_full_occurrence_individual_new (fk_tnrs_id);
CREATE INDEX vfoi_new_family_matched_idx ON view_full_occurrence_individual_new (family_matched);
CREATE INDEX vfoi_new_name_matched_idx ON view_full_occurrence_individual_new (name_matched);
CREATE INDEX vfoi_new_matched_taxonomic_status_idx ON view_full_occurrence_individual_new (matched_taxonomic_status);
CREATE INDEX vfoi_new_match_summary_idx ON view_full_occurrence_individual_new (match_summary);
CREATE INDEX vfoi_new_scrubbed_taxonomic_status_idx ON view_full_occurrence_individual_new (scrubbed_taxonomic_status);
CREATE INDEX vfoi_new_higher_plant_group_idx ON view_full_occurrence_individual_new (higher_plant_group);
CREATE INDEX vfoi_new_scrubbed_family_idx ON view_full_occurrence_individual_new (scrubbed_family);
CREATE INDEX vfoi_new_scrubbed_genus_idx ON view_full_occurrence_individual_new (scrubbed_genus);
CREATE INDEX vfoi_new_scrubbed_species_binomial_idx ON view_full_occurrence_individual_new (scrubbed_species_binomial);
CREATE INDEX vfoi_new_scrubbed_taxon_name_no_author_idx ON view_full_occurrence_individual_new (scrubbed_taxon_name_no_author);
CREATE INDEX vfoi_new_scrubbed_species_binomial_with_morphospecies_idx ON view_full_occurrence_individual_new (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX vfoi_new_growth_form_idx ON view_full_occurrence_individual_new (growth_form);
CREATE INDEX vfoi_new_cites_idx ON view_full_occurrence_individual_new (cites);
CREATE INDEX vfoi_new_iucn_idx ON view_full_occurrence_individual_new (iucn);
CREATE INDEX vfoi_new_usda_federal_idx ON view_full_occurrence_individual_new (usda_federal);
CREATE INDEX vfoi_new_usda_state_idx ON view_full_occurrence_individual_new (usda_state);
CREATE INDEX vfoi_new_is_embargoed_observation_idx ON view_full_occurrence_individual_new (is_embargoed_observation);
CREATE INDEX vfoi_new_native_status_idx ON view_full_occurrence_individual_new (native_status);
CREATE INDEX vfoi_new_is_introduced_idx ON view_full_occurrence_individual_new (is_introduced);
CREATE INDEX vfoi_new_is_cultivated_in_region_idx ON view_full_occurrence_individual_new (is_cultivated_in_region);
CREATE INDEX vfoi_new_is_cultivated_taxon_idx ON view_full_occurrence_individual_new (is_cultivated_taxon);
CREATE INDEX vfoi_new_is_cultivated_observation_idx ON view_full_occurrence_individual_new (is_cultivated_observation);
CREATE INDEX vfoi_new_geom_not_null_idx ON
view_full_occurrence_individual_new(is_geovalid)
WHERE geom IS NOT NULL; -- indexed column not important
CREATE INDEX vfoi_new_georef_protocol_idx ON view_full_occurrence_individual_new (georef_protocol);
CREATE INDEX vfoi_new_is_location_cultivated_idx ON view_full_occurrence_individual_new (is_location_cultivated);

CREATE INDEX vfoi_new_gid_0_idx ON view_full_occurrence_individual_new (gid_0);
CREATE INDEX vfoi_new_gid_1_idx ON view_full_occurrence_individual_new (gid_1);
CREATE INDEX vfoi_new_gid_2_idx ON view_full_occurrence_individual_new (gid_2);
CREATE INDEX vfoi_new_fk_cds_id_idx ON view_full_occurrence_individual_new (fk_cds_id);
CREATE INDEX vfoi_new_is_centroid_idx ON view_full_occurrence_individual_new (is_centroid);
CREATE INDEX vfoi_new_centroid_type_idx ON view_full_occurrence_individual_new (centroid_type);
CREATE INDEX vfoi_new_is_invalid_latlong_idx ON view_full_occurrence_individual_new (is_invalid_latlong);
CREATE INDEX vfoi_new_nsr_id_idx ON view_full_occurrence_individual_new (nsr_id	);
CREATE INDEX vfoi_new_cods_proximity_id_idx ON view_full_occurrence_individual_new (cods_proximity_id);
CREATE INDEX vfoi_new_cods_keyword_id_idx ON view_full_occurrence_individual_new (cods_keyword_id);
CREATE INDEX vfoi_new_latlong_verbatim_idx ON view_full_occurrence_individual_new(latlong_verbatim);
CREATE INDEX vfoi_new_datasetkey_idx ON view_full_occurrence_individual_new (datasetkey);


-- Default BIEN range modelling index
-- Covering partial index
CREATE INDEX vfoi_new_bien_range_model_default_idx ON view_full_occurrence_individual_new (
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
AND is_invalid_latlong=0 
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND (is_centroid IS NULL OR is_centroid=0)
AND is_location_cultivated IS NULL
AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)')
AND (is_introduced=0 OR is_introduced IS NULL)
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
AND ( EXTRACT(YEAR FROM event_date)>=1950 OR event_date IS NULL )
;

--
-- Spatial indexes and constraints
-- 

-- Geometry dimensions must be 2 (point)
ALTER TABLE view_full_occurrence_individual_new DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE view_full_occurrence_individual_new
   ADD CONSTRAINT enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE view_full_occurrence_individual_new DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE view_full_occurrence_individual_new
   ADD CONSTRAINT enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) is 4326 (WGS84)
ALTER TABLE view_full_occurrence_individual_new DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE view_full_occurrence_individual_new
   ADD CONSTRAINT enforce_srid_geom
   CHECK (ST_SRID(geom) = 4326);
   
-- Restore geometry indices
CREATE INDEX vfoi_new_georeferenced_species_idx ON view_full_occurrence_individual_new USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

DROP INDEX IF EXISTS vfoi_new_gist_idx;
CREATE INDEX vfoi_new_gist_idx ON view_full_occurrence_individual_new USING gist (geom);

