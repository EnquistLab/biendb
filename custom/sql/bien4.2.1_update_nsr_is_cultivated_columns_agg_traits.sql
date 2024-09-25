set search_path to :sch;

UPDATE agg_traits a
SET is_cultivated_taxon=b.is_cultivated_taxon,
is_cultivated_in_region=b.is_cultivated_in_region
FROM nsr b
WHERE (b.is_cultivated_taxon='1' OR b.is_cultivated_in_region='1')
AND a.nsr_id=b.id
;
