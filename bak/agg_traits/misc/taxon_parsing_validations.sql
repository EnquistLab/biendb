set search_path to vegbien_dev;

select distinct verbatim_scientific_name, family_matched, name_matched, name_matched_author, matched_taxonomic_status
from agg_traits
limit 12;

select distinct verbatim_scientific_name, name_matched, name_matched_author, matched_taxonomic_status, scrubbed_taxonomic_status, scrubbed_taxon_name_with_author
from agg_traits
limit 12;

select distinct verbatim_scientific_name, scrubbed_taxonomic_status, scrubbed_family, scrubbed_genus, scrubbed_specific_epithet, scrubbed_species_binomial, scrubbed_taxon_name_no_author
from agg_traits 
where scrubbed_taxon_name_no_author like '%var.%'
limit 12;

select distinct verbatim_family, verbatim_scientific_name, tnrs_warning, scrubbed_taxonomic_status as scrubbed_status, scrubbed_family, scrubbed_taxon_name_no_author, scrubbed_species_binomial_with_morphospecies
from agg_traits 
where scrubbed_taxon_name_no_author<>scrubbed_species_binomial_with_morphospecies
limit 12;

select distinct verbatim_family, verbatim_scientific_name, name_matched,scrubbed_taxonomic_status, scrubbed_family, scrubbed_taxon_name_no_author, scrubbed_species_binomial_with_morphospecies
from agg_traits 
where tnrs_warning is not null
limit 12;


select verbatim_scientific_name, scrubbed_taxonomic_status, scrubbed_family, scrubbed_genus, scrubbed_specific_epithet, scrubbed_species_binomial, scrubbed_taxon_name_no_author, scrubbed_taxon_canonical, scrubbed_author, scrubbed_taxon_name_with_author, scrubbed_species_binomial_with_morphospecies
from agg_traits 
limit 12;

select distinct verbatim_scientific_name, scrubbed_taxon_name_no_author, scrubbed_taxon_canonical
from agg_traits
limit 12
;

select distinct verbatim_scientific_name, scrubbed_taxon_name_no_author, scrubbed_taxon_canonical
from agg_traits
where scrubbed_taxon_name_no_author like '%.%' and scrubbed_taxon_name_no_author not like '%var.%' and scrubbed_taxon_name_no_author not like '%subsp.%' and scrubbed_taxon_name_no_author not like '%fo.%' 
limit 12
;

select distinct verbatim_scientific_name, scrubbed_taxon_name_no_author, scrubbed_taxon_canonical
from agg_traits
where scrubbed_taxon_name_no_author like '%Vasconcellea%' 
limit 12
;

select distinct verbatim_scientific_name, scrubbed_taxon_name_no_author, scrubbed_taxon_canonical
from agg_traits
where scrubbed_taxon_name_no_author like '%×%' 
limit 12
;

select warnings, count(*) 
from taxon_verbatim_scrubbed a join taxon_verbatim_parsed b 
on a.user_id=b.user_id
where a.name_matched_rank<>b.taxon_parsed_rank 
and a.selected='true' 
AND a.name_matched_rank NOT IN ('forma','infraspecies','variety','subspecies')
group by warnings;

select distinct name_matched_rank, taxon_parsed_rank 
from taxon_verbatim_scrubbed a join taxon_verbatim_parsed b 
on a.user_id=b.user_id
where a.name_matched_rank<>b.taxon_parsed_rank 
and a.selected='true' 
;


