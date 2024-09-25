-- -----------------------------------------------------------------
-- Validations on bien_taxonomy & related tables
-- -----------------------------------------------------------------

-- 
--  taxonomic status
-- 

-- not null scrubbed_taxonomic_status
select higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, trim(scrubbed_taxonomic_status) as taxonomic_status, bien_taxonomy_id
from bien_taxonomy 
where scrubbed_taxonomic_status is not null 
limit 12;

-- Count of names by scrubbed_taxonomic_status
select scrubbed_taxonomic_status, count(*) as names
from bien_taxonomy 
group by scrubbed_taxonomic_status;

-- Inspect records with NULL scrubbed_taxonomic_status
select higher_plant_group, scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author, trim(scrubbed_taxonomic_status) as taxonomic_status, bien_taxonomy_id
from bien_taxonomy 
where scrubbed_taxonomic_status IS NULL 
limit 12;

-- null scrubbed_taxonomic_status
select COUNT(b.*)
from view_full_occurrence_individual a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
where b.scrubbed_taxonomic_status is null 
AND a.taxonomic_status is not null;

-- compare taxonomic status
select b.higher_plant_group, b.scrubbed_family as family, b.scrubbed_taxon_name_no_author as taxon, b.scrubbed_author as author, a. taxonomic_status, trim(scrubbed_taxonomic_status) as scrubbed_taxonomic_status
from view_full_occurrence_individual a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
LIMIT 12;


-- 
-- missing families
-- 
select b.higher_plant_group, b.scrubbed_family as family, b.scrubbed_taxon_name_no_author as taxon, b.scrubbed_author as author, a. taxonomic_status, trim(scrubbed_taxonomic_status) as scrubbed_taxonomic_status
from view_full_occurrence_individual a JOIN bien_taxonomy b
on a.bien_taxonomy_id=b.bien_taxonomy_id
where b.scrubbed_family is not null and a.scrubbed_family is null
LIMIT 12;

-- 
-- higher taxa
-- 
select higher_plant_group, 
trim(division) as division, 
trim("class") as "class", trim(subclass) as subclass, 
trim(superorder) as superorder, trim("order") as "order", 
scrubbed_family as family, scrubbed_taxon_name_no_author as taxon, scrubbed_author as author
from bien_taxonomy
where "order"<>''
LIMIT 12;

select higher_plant_group, trim(division) as division, 
trim("class") as "class", trim(subclass) as subclass, 
trim(superorder) as superorder, trim("order") as "order", 
count(*) as names
from bien_taxonomy
group by higher_plant_group, division, "class", subclass, superorder, "order"
order by higher_plant_group, division, "class", subclass, superorder, "order"
;

-- Check mis-classified taxa
SELECT * 
FROM bien_taxonomy
WHERE higher_plant_group='bryophytes'
AND (subclass='Magnoliidae' OR subclass IS NOT NULL)
;

SELECT * 
FROM bien_taxonomy
WHERE higher_plant_group='flowering plants'
AND division='Ascomycota'
LIMIT 12;

SELECT scrubbed_species_binomial, scrubbed_family, COUNT(*) 
FROM bien_taxonomy
WHERE higher_plant_group='flowering plants'
AND division='Ascomycota'
GROUP BY scrubbed_species_binomial, scrubbed_family
ORDER BY scrubbed_species_binomial, scrubbed_family;

SELECT * 
FROM bien_taxonomy
WHERE higher_plant_group='ferns and allies'
AND subclass='Magnoliidae'
LIMIT 12;

SELECT * 
FROM bien_taxonomy
WHERE higher_plant_group='flowering plants'
AND subclass='Polypodiidae'
LIMIT 12;

SELECT * 
FROM bien_taxonomy
WHERE higher_plant_group IS NULL
AND "class"='Equisetopsida'
LIMIT 12;

