-- ----------------------------------------------------------------
-- Manual checks and validations, not part of bien db pipeline
-- ----------------------------------------------------------------

\c vegbien
set search_path to analytical_db_dev;

--
-- Final records to delete
-- 

select count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource NOT IN ('VegBank','CVS')
;

select datasource, major_taxon, count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource NOT IN ('VegBank','CVS')
GROUP BY datasource, major_taxon
ORDER BY datasource, major_taxon
;

--
-- Details of remaining non-embryophyte records
-- 

select datasource, major_taxon, count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource IN ('VegBank','CVS')
GROUP BY datasource, major_taxon
ORDER BY datasource, major_taxon
;

SELECT b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author as scrubbed_taxon, count(*)
FROM view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource  IN ('VegBank','CVS')
GROUP BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
ORDER BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
;


SELECT b.*
FROM view_full_occurrence_individual a JOIN tnrs b
ON a.fk_tnrs_id=b.tnrs_id
WHERE a.datasource IN ('VegBank','CVS')
AND b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.higher_plant_group IS NOT NULL
LIMIT 1;
; 


--
-- Other validations
-- 


SELECT tnrs_id,
name_submitted_verbatim,
family_submitted,
species_submitted,
scrubbed_family,
scrubbed_taxon_name_no_author,
major_taxon
FROM tnrs
WHERE major_taxon IS NOT NULL
LIMIT 12;

-- Records to delete
-- Selected non-embryophytes
SELECT COUNT(*) 
FROM tnrs
WHERE major_taxon IN (
'Animalia',
'Archaea',
'Bacteria',
'Euglenophyta',
'Misc unicellular eukaryotes',
'Protists',
'Undetermined non-embryophyte'
);

select count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon IN (
'Animalia',
'Archaea',
'Bacteria',
'Euglenophyta',
'Misc unicellular eukaryotes',
'Protists',
'Undetermined non-embryophyte'
);

-- All non-embryophytes
SELECT COUNT(*) 
FROM tnrs
WHERE major_taxon<>'Embryophyta'
AND major_taxon IS NOT NULL
;

select count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
;

-- get datasources linked to above records
SELECT datasource, count(*)
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
group by datasource
order by datasource
;

-- count observations per datasource * higher taxon
-- for non-embryophyte taxa
SELECT datasource, major_taxon, count(*)
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
group by datasource, major_taxon
order by datasource, major_taxon
;

-- As above, major taxon first
SELECT major_taxon, datasource, count(*)
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
group by major_taxon, datasource
order by major_taxon, datasource
;

-- As above, major taxon first
SELECT major_taxon, datasource, count(*)
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource NOT IN ('GBIF','SpeciesLink','REMIB')
group by major_taxon, datasource
order by major_taxon, datasource
;


-- get datasources linked to animal records
SELECT datasource, count(*)
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon='Animalia'
group by datasource
order by datasource
;

-- List bad taxa not in 'GBIF','SpeciesLink','REMIB'
SELECT b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author as scrubbed_taxon, count(*)
FROM view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta'
AND b.major_taxon IS NOT NULL
AND a.datasource NOT IN ('GBIF','SpeciesLink','REMIB')
GROUP BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
ORDER BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
;

-- List fungi and algae in 'GBIF','SpeciesLink','REMIB'
SELECT b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author as scrubbed_taxon, count(*)
FROM view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon IN ('Fungi','Algae')
AND b.major_taxon IS NOT NULL
AND a.datasource IN ('GBIF','SpeciesLink','REMIB')
GROUP BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
ORDER BY b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
;


-- List animal taxa in chilesp, MO, NY
SELECT datasource, b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author as scrubbed_taxon,
count(*)
FROM view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon='Animalia'
AND a.datasource in ('chilesp','MO','NY')
GROUP BY datasource, b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
ORDER BY datasource, b.major_taxon, a.higher_plant_group, b.family_submitted, b.species_submitted, a.scrubbed_family, a.scrubbed_taxon_name_no_author
;



-- All major taxa
select major_taxon, count(*)
from tnrs
group by major_taxon
order by major_taxon
;

-- All verbatim names
select count(*) 
from tnrs
;

-- Known non-embryophyte names
select count(*) 
from tnrs
where major_taxon<>'Embryophyta' AND major_taxon IS NOT NULL
;

-- Known animal names
select count(*) 
from tnrs
where major_taxon='Animalia' 
;


-- All obs
select count(*) 
from view_full_occurrence_individual
;


-- Non-embryophytes
select count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon<>'Embryophyta' AND b.major_taxon IS NOT NULL
;


-- Animals
select count(*) 
from view_full_occurrence_individual a join tnrs b 
on a.fk_tnrs_id=b.tnrs_id 
where b.major_taxon='Animalia'
;


 select 
 name_submitted, 
 split_part(name_submitted, ' ', 1) AS animal_family 
 from tnrs 
 where split_part(name_submitted, ' ', 1) like '%idae%' 
 order by split_part(name_submitted, ' ', 1)
 ;
 
 select name_submitted,
 family_submitted, species_submitted, 
 family_matched, name_matched, 
 scrubbed_family, scrubbed_taxon_name_no_author,
 scrubbed_species_binomial_with_morphospecies as morphospecies
 from tnrs
 where split_part(name_submitted, ' ', 1) like '%idae%'
 and name_matched is not null
 limit 12;
 
select name_submitted,
major_taxon,
family_matched, name_matched, 
scrubbed_family, scrubbed_taxon_name_no_author,
scrubbed_species_binomial_with_morphospecies as morphospecies
from tnrs
where split_part(name_submitted, ' ', 1) like '%idae%'
and name_matched is not null
limit 12;