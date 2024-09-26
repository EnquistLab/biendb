-- -------------------------------------------------------------------------------
-- is_range_model_obs index tests
--
-- 	NOT RUN, FOR TESTING ONLY
-- -------------------------------------------------------------------------------

\c vegbien
set search_path to analytical_db;

--
-- Base query using default BIEN WHERE clause
-- 

EXPLAIN ANALYZE
SELECT scrubbed_species_binomial, latitude, longitude, date_collected, datasource, dataset, dataowner, custodial_institution_codes, collection_code, view_full_occurrence_individual.datasource_id
FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial in ( 'Baileya multiradiata' )
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
AND is_location_cultivated IS NULL
AND (is_introduced=0 OR is_introduced IS NULL)
AND observation_type IN ('plot','specimen','literature','checklist')
AND is_geovalid = 1
AND higher_plant_group NOT IN ('Algae','Bacteria','Fungi')
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND (is_centroid IS NULL OR is_centroid=0)
AND scrubbed_species_binomial IS NOT NULL
;

/*
Run 1:

 Bitmap Heap Scan on view_full_occurrence_individual  (cost=516.88..62592.83 rows=2299 width=101) (actual time=76.676..22509.696 rows=1020 loops=1)
   Recheck Cond: ((scrubbed_species_binomial IS NOT NULL) AND (scrubbed_species_binomial = 'Baileya multiradiata'::text))
   Filter: ((is_location_cultivated IS NULL) AND ((is_cultivated_observation = 0) OR (is_cultivated_observation IS NULL)) AND ((is_introduced = 0) OR (is_introduced IS NULL)) AND ((georef_protocol IS NULL) OR (georef_protocol <> 'county centroid'::text)) AND ((is_centroid IS NULL) OR (is_centroid = 0)) AND (is_geovalid = 1) AND (higher_plant_group <> ALL ('{Algae,Bacteria,Fungi}'::text[])) AND ((observation_type)::text = ANY ('{plot,specimen,literature,checklist}'::text[])))
   Rows Removed by Filter: 2046
   Heap Blocks: exact=3066
   ->  Bitmap Index Scan on vfoi_scrubbed_species_binomial_idx  (cost=0.00..516.30 rows=15573 width=0) (actual time=64.093..64.093 rows=3066 loops=1)
         Index Cond: ((scrubbed_species_binomial IS NOT NULL) AND (scrubbed_species_binomial = 'Baileya multiradiata'::text))
 Planning Time: 2.481 ms
 Execution Time: 22510.279 ms (22.5 sec)
 
Run 2:

 Planning Time: 2.482 ms
 Execution Time: 16.013 ms
*/



--
-- Test 1
-- 

/*
Index:

CREATE INDEX vfoi_is_range_model_obs_idx ON view_full_occurrence_individual
USING btree (is_range_model_obs, scrubbed_species_binomial)
WHERE is_range_model_obs=1
;
*/


EXPLAIN ANALYZE
SELECT scrubbed_species_binomial, latitude, longitude, date_collected, datasource, dataset, dataowner, custodial_institution_codes, collection_code, view_full_occurrence_individual.datasource_id
FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial in ( 'Baileya multiradiata' )
AND is_range_model_obs=1
;

/* Run 1:

 Bitmap Heap Scan on view_full_occurrence_individual  (cost=504.42..65758.19 rows=1768 width=101) (actual time=1.948..14.965 rows=1020 loops=1)
   Recheck Cond: (scrubbed_species_binomial = 'Baileya multiradiata'::text)
   Filter: (is_range_model_obs = 1)
   Rows Removed by Filter: 2046
   Heap Blocks: exact=3066
   ->  Bitmap Index Scan on vfoi_scrubbed_species_binomial_idx  (cost=0.00..503.98 rows=16454 width=0) (actual time=1.072..1.072 rows=3066 loops=1)
         Index Cond: (scrubbed_species_binomial = 'Baileya multiradiata'::text)
 Planning Time: 0.842 ms
 Execution Time: 15.114 ms

Run 2:

 Planning Time: 0.777 ms
 Execution Time: 14.496 ms
*/

--
-- Test 2
-- 

/*
Index:

DROP INDEX IF EXISTS vfoi_is_range_model_obs_idx;
CREATE INDEX vfoi_is_range_model_obs_idx ON view_full_occurrence_individual
USING btree (is_range_model_obs)
WHERE is_range_model_obs=1
;
*/

-- Reusing previous query
EXPLAIN ANALYZE
SELECT scrubbed_species_binomial, latitude, longitude, date_collected, datasource, dataset, dataowner, custodial_institution_codes, collection_code, view_full_occurrence_individual.datasource_id
FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial in ( 'Baileya multiradiata' )
AND is_range_model_obs=1
;

/*
 Bitmap Heap Scan on view_full_occurrence_individual  (cost=494.32..64644.25 rows=1767 width=101) (actual time=2.266..10.202 rows=1020 loops=1)
   Recheck Cond: (scrubbed_species_binomial = 'Baileya multiradiata'::text)
   Filter: (is_range_model_obs = 1)
   Rows Removed by Filter: 2046
   Heap Blocks: exact=3066
   ->  Bitmap Index Scan on vfoi_scrubbed_species_binomial_idx  (cost=0.00..493.88 rows=16174 width=0) (actual time=1.361..1.361 rows=3066 loops=1)
         Index Cond: (scrubbed_species_binomial = 'Baileya multiradiata'::text)
 Planning Time: 6.480 ms
 Execution Time: 10.380 ms
*/

-- New query parameter
EXPLAIN ANALYZE
SELECT scrubbed_species_binomial, latitude, longitude, date_collected, datasource, dataset, dataowner, custodial_institution_codes, collection_code, view_full_occurrence_individual.datasource_id
FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial in ( 'Justicia californica' )
AND is_range_model_obs=1
;

/*

Run 1: 

 Planning Time: 0.736 ms
 Execution Time: 20758.925 ms


Run 2:


 Planning Time: 1.105 ms
 Execution Time: 14.071 ms
*/


EXPLAIN ANALYZE
SELECT scrubbed_species_binomial, latitude, longitude, date_collected, datasource, dataset, dataowner, custodial_institution_codes, collection_code, view_full_occurrence_individual.datasource_id
FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial in ( 'Thuja plicata' )
AND is_range_model_obs=1
;


