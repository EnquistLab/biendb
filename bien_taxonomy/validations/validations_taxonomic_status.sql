-- taxonomic status validations

-- not null taxonomic status
select higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, scrubbed_taxonomic_status as taxonomic_status, bien_taxonomy_id, bien_taxonomy_id_txt
from bien_taxonomy 
where scrubbed_taxonomic_status is not null 
limit 12;

--
-- null taxonomic status
--
select COUNT(b.*)
from view_full_occurrence_individual_new a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
where b.scrubbed_taxonomic_status is null 
AND a.taxonomic_status is not null;

select count(*)
from view_full_occurrence_individual_new
where bien_taxonomy_id is null;

select a.bien_taxonomy_id, a.bien_taxonomy_id_txt, a.higher_plant_group, a.scrubbed_family as family, a.scrubbed_species_binomial, a.scrubbed_taxon_name_no_author as taxon, a.scrubbed_author as author, 
a.taxonomic_status as taxonomic_status                                                                              
from view_full_occurrence_individual_new a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
where b.scrubbed_taxonomic_status is null 
and a.taxonomic_status is not null
;

select distinct a.higher_plant_group, a.scrubbed_family as family, a.scrubbed_taxon_name_no_author as taxon, a.scrubbed_author as author, 
a.taxonomic_status as taxonomic_status                                                                              
from view_full_occurrence_individual_new a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
where b.scrubbed_taxonomic_status is null or b.scrubbed_taxonomic_status=''
;

select bien_taxonomy_id_txt, higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, 
taxonomic_status as taxonomic_status                                                                              
from view_full_occurrence_individual_new
where bien_taxonomy_id_txt='' limit 12;





select higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, scrubbed_taxonomic_status as taxonomic_status, bien_taxonomy_id, bien_taxonomy_id_txt
from bien_taxonomy 
where scrubbed_taxonomic_status is null or scrubbed_taxonomic_status=''
limit 12;

select distinct higher_plant_group
from bien_taxonomy 
where scrubbed_taxonomic_status is null or scrubbed_taxonomic_status=''
limit 12;



select scrubbed_taxonomic_status, count(*) as names
from bien_taxonomy 
group by scrubbed_taxonomic_status;


select taxonobservation_id, bien_taxonomy_id,
higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, 
taxonomic_status as taxonomic_status
from view_full_occurrence_individual 
where scrubbed_species_binomial in (
'Tripteris vaillantii',
'Vinicia tomentosa',
'Abarema microcalyx',
'Agave angustifolia'
);

select distinct higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, 
taxonomic_status as taxonomic_status                                                                              
from view_full_occurrence_individual_new a JOIN bien_taxonomy b
ON a.
where bien_taxonomy_id_txt='' limit 12;