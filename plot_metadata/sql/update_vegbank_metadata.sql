-- 
--  Create table plot_metadata
--

SET search_path TO :dev_schema;

UPDATE plot_metadata AS a
SET
plot_area_ha=b.plot_area_ha,
sampling_protocol='',
abundance_measurement=b.abundance_measurement,
has_strata=b.has_strata,
has_stem_data=b.has_stem_data,
stem_diam_min=b.stem_diam_min,
stem_diam_min_units=b.stem_diam_min_units,
growth_forms_included_trees=b.growth_forms_included_trees,
growth_forms_included_shrubs=b.growth_forms_included_shrubs,
growth_forms_included_lianas=b.growth_forms_included_lianas,
growth_forms_included_herbs=b.growth_forms_included_herbs,
growth_forms_included_epiphytes=b.growth_forms_included_epiphytes,
taxa_included_seed_plants=b.taxa_included_seed_plants,
taxa_included_ferns_lycophytes=b.taxa_included_ferns_lycophytes,
taxa_included_bryophytes=b.taxa_included_bryophytes
FROM metadata_vegbank AS b
WHERE a.dataSource='VegBank'
AND a.plot_name=b.authorobscode
;