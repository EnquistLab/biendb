ALTER TABLE agg_traits ADD COLUMN fk_taxon_poldiv TEXT DEFAULT NULL;

UPDATE agg_traits
SET fk_taxon_poldiv=CONCAT_WS('@',
COALESCE(scrubbed_family,''),
COALESCE(scrubbed_genus,''),
COALESCE(scrubbed_species_binomial,''),
COALESCE(country,''),
COALESCE(state_province,''),
COALESCE(county,'')
)
;

-- Check nsr has index on taxon_poldiv!!!
\d nsr
CREATE INDEX agg_traits_fk_taxon_poldiv_idx ON agg_traits (fk_taxon_poldiv);

UPDATE agg_traits a
SET 
nsr_id=b.id,
native_status_country=b.native_status_country,
native_status_state_province=b.native_status_state_province,
native_status_county_parish=b.native_status_county_parish,
native_status=b.native_status,
native_status_reason=b.native_status_reason,
native_status_sources=b.native_status_sources,
isintroduced=b.isintroduced,
is_cultivated_in_region=b.is_cultivated_in_region,
is_cultivated_taxon=b.is_cultivated_taxon
FROM nsr b
WHERE a.fk_taxon_poldiv=b.taxon_poldiv
;

DROP INDEX agg_traits_fk_taxon_poldiv_idx;