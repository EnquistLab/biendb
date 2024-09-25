-- These tables determined by wildcard searches on 'bak', 'staging' 
-- and 'raw'
DROP TABLE IF EXISTS 
agg_traits_bak_20022108,
agg_traits_bak_21022018,
ala_raw,
analytical_stem_dev_bak_21022018,
centroid_dupe_records_bak,
chilesp_raw,
datasource_raw,
dryflor_raw,
gillespie_people_raw,
gillespie_plot_data_raw,
gillespie_plot_descriptions_raw,
nsr_submitted_raw,
ntt_areas_raw,
ntt_sources_areas_raw,
ntt_sources_raw,
ntt_species_areas_raw,
ntt_species_raw,
rainbio_raw,
schep_plotdb_raw,
schep_tree_db_raw,
tnrs_bak,
traits_raw,
view_full_occurrence_individual_dev_bak_20180208,
view_full_occurrence_individual_dev_bak_21022018,
analytical_stem_staging,
datasource_staging,
plot_metadata_staging,
vfoi_staging
;

-- These tables determined by inspection
DROP TABLE IF EXISTS 
agg_traits_dupes_delete,
centroid_dupe_ids,
centroid_dupe_records,
cultobs_descriptions,
cultobs_herb_dist,
cultobs_herb_min_dist,
cultobs_herbaria,
cultobs_sample,
endangered_taxa_verbatim,
endangered_taxa_by_state,
endangered_taxa_by_source,
plot_provenance,
proximate_providers,
taxon_verbatim_parsed,
taxon_verbatim_scrubbed,
us_states,
geov_dupe_ids,
geov_dupe_records,
gnrs_dup,
gnrs_ih,
name_parsed,
name_scrubbed,
name_submitted,
nsr_submitted,
vfoi_dup,
herbaria
;

DROP SEQUENCE IF EXISTS endangered_taxa_by_source_endangered_taxa_by_source_id_seq;

DROP TABLE IF EXISTS tnrs_scrubbed CASCADE;
DROP TABLE IF EXISTS tnrs_submitted CASCADE;