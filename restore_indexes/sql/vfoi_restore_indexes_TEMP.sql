--
-- SINGLE USE ONLY TO RECOVER FROM ERROR
-- DELETE AFTER USE!
-- 

SET search_path TO :sch, postgis;

CREATE INDEX vfoi_cods_proximity_id_idx ON view_full_occurrence_individual (cods_proximity_id);
CREATE INDEX vfoi_cods_keyword_id_idx ON view_full_occurrence_individual (cods_keyword_id);


-- Default BIEN range modelling index
-- Covering partial index
CREATE INDEX vfoi_bien_range_model_default_idx ON view_full_occurrence_individual (
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
WHERE scrubbed_species_binomial IS NOT NULL AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND is_location_cultivated IS NULL AND is_invalid_latlong=0 AND is_geovalid = 1 AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) AND (georef_protocol is NULL OR georef_protocol<>'county_centroid') AND (is_centroid IS NULL OR is_centroid=0) AND ( EXTRACT(YEAR FROM event_date)>=1970 OR event_date IS NULL ) AND (is_introduced=0 OR is_introduced IS NULL) AND observation_type IN ('plot','specimen','literature','checklist')  
;

--
-- Spatial indexes and constraints
-- 

-- Geometry dimensions must be 2 (point)
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE view_full_occurrence_individual
   ADD CONSTRAINT enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE view_full_occurrence_individual
   ADD CONSTRAINT enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) is 4326 (WGS84)
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE view_full_occurrence_individual
   ADD CONSTRAINT enforce_srid_geom
   CHECK (ST_SRID(geom) = 4326);
   
-- Restore geometry indices
CREATE INDEX vfoi_georeferenced_species_idx ON view_full_occurrence_individual USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

DROP INDEX IF EXISTS vfoi_gist_idx;
CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual USING gist (geom);


   

