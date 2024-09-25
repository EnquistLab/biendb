-- --------------------------------------------------------------------
-- Removes sequences for pkeys. Unnecessary for data warehouse built
-- from scratch each time
-- Nb. Don't drop for bien_metadata, may need seq for minor version
-- updates
-- --------------------------------------------------------------------

ALTER TABLE bien_summary ALTER COLUMN bien_summary_id DROP DEFAULT;
DROP SEQUENCE bien_summary_bien_summary_id_seq;

ALTER TABLE bien_taxonomy ALTER COLUMN bien_taxonomy_id DROP DEFAULT;
DROP SEQUENCE bien_taxonomy_bien_taxonomy_id_seq;

ALTER TABLE centroid ALTER COLUMN centroid_id DROP DEFAULT;
DROP SEQUENCE centroid_centroid_id_seq;

ALTER TABLE cultobs ALTER COLUMN cultobs_id DROP DEFAULT;
DROP SEQUENCE cultobs_cultobs_id_seq;

ALTER TABLE datasource ALTER COLUMN datasource_id DROP DEFAULT;
DROP SEQUENCE datasource_datasource_id_seq;

ALTER TABLE endangered_taxa ALTER COLUMN endangered_taxa_id DROP DEFAULT;
DROP SEQUENCE endangered_taxa_endangered_taxa_id_seq;

ALTER TABLE nsr_submitted ALTER COLUMN user_id DROP DEFAULT;
DROP SEQUENCE nsr_submitted_user_id_seq;

ALTER TABLE phylogeny ALTER COLUMN phylogeny_id DROP DEFAULT;
DROP SEQUENCE phylogeny_phylogeny_id_seq;

ALTER TABLE plot_metadata ALTER COLUMN plot_metadata_id DROP DEFAULT;
DROP SEQUENCE plot_metadata_plot_metadata_id_seq;

ALTER TABLE species_by_political_division ALTER COLUMN species_by_political_division_id DROP DEFAULT;
DROP SEQUENCE species_by_political_division_species_by_political_division_seq;

ALTER TABLE taxon ALTER COLUMN taxon_id DROP DEFAULT;
DROP SEQUENCE taxon_taxon_id_seq;

ALTER TABLE tnrs ALTER COLUMN tnrs_id DROP DEFAULT;
DROP SEQUENCE tnrs_tnrs_id_seq;

