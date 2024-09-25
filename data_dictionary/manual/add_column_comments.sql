COMMENT ON COLUMN agg_traits.id IS 'Artificial integer identifier (primary key)';
COMMENT ON COLUMN agg_traits.traits_id IS 'Legacy ID from previous version of traits table';
COMMENT ON COLUMN agg_traits.bien_taxonomy_id IS 'Foreign key to table bien_taxonomy';
COMMENT ON COLUMN agg_traits.taxon_id IS 'Foreign key to taxon in table taxon';
COMMENT ON COLUMN agg_traits.family_taxon_id IS 'Foreign key to family in table taxon';
COMMENT ON COLUMN agg_traits.genus_taxon_id IS 'Foreign key to genus in table taxon';
COMMENT ON COLUMN agg_traits.species_taxon_id IS 'Foreign key to species in table taxon';
COMMENT ON COLUMN agg_traits.fk_tnrs_id IS 'Foreign key to table tnrs';
COMMENT ON COLUMN agg_traits.verbatim_family IS 'Verbatim family name, if provided';
COMMENT ON COLUMN agg_traits.verbatim_scientific_name IS 'Verbatim taxon name';
COMMENT ON COLUMN agg_traits.name_submitted IS 'Name submitted to TNRS; usually = verbatim_family + verbatim_scientific_name, with corrections for characters not handled by TNRS';


COMMENT ON COLUMN agg_traits.xx IS 'xxx';
COMMENT ON COLUMN agg_traits.xx IS 'xxx';
COMMENT ON COLUMN agg_traits.xx IS 'xxx';
COMMENT ON COLUMN agg_traits.xx IS 'xxx';
COMMENT ON COLUMN agg_traits.xx IS 'xxx';


