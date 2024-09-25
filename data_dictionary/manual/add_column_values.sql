TRUNCATE data_dictionary_values;
INSERT INTO data_dictionary_values (
table_name,
column_name,
values
) 
VALUES
('agg_traits','is_centroid','{"0","1"}'),
('agg_traits','is_in_country','{"0","1"}'),
('agg_traits','is_in_state_province','{"0","1"}'),
('agg_traits','is_in_county','{"0","1"}'),
('agg_traits','is_geovalid','{"0","1"}'),
('agg_traits','is_new_world','{"0","1"}'),
('agg_traits','is_experiment','{"0","1"}'),
('agg_traits','is_individual_trait','{"0","1"}'),
('agg_traits','is_species_trait','{"0","1"}'),
('agg_traits','is_trait_value_valid','{"0","1"}'),
('agg_traits','is_individual_measurement','{"0","1"}'),
('agg_traits','is_embargoed_observation','{"0","1"}'),
('agg_traits','native_status_country','{"N","Ne","I","Ie","A","P","UNK"}'),
('agg_traits','native_status_state_province','{"N","Ne","I","Ie","A","P","UNK"}'),
('agg_traits','native_status_county_parish','{"N","Ne","I","Ie","A","P","UNK"}'),
('agg_traits','native_status','{"N","Ne","I","Ie","A","P","UNK"}'),
('agg_traits','is_introduced','{"0","1"}'),
('agg_traits','is_cultivated_in_region','{"0","1"}'),
('agg_traits','is_cultivated_taxon','{"0","1"}'),
('agg_traits','is_cultivated_observation','{"0","1"}'),
('agg_traits','is_cultivated_observation_basis','{"0","1"}')
;

