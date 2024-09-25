-- 
-- Some important stats to figure out best way to loop through vfoi
-- 

set search_path to analytical_db;

-- Total records vfoi
-- 100538252
select count(*) from view_full_occurrence_individual;

-- Total potentially geovalid records not identified to species
-- 4831188
select count(*) from view_full_occurrence_individual
where scrubbed_species_binomial IS NULL 
AND latitude IS NOT NULL AND longitude IS NOT NULL
;

-- Total potentially geovalid records not identified to species
-- with non-null country
-- 4474908
select count(*) from view_full_occurrence_individual
where scrubbed_species_binomial IS NULL 
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country is not null
;
-- highest counts of observation for potentially geovalid records
--  United States |  932590
SELECT country, count(*) as records
from view_full_occurrence_individual
where scrubbed_species_binomial IS NULL 
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country is not null
group by country
order by count(*) desc
limit 12
;


-- Total potentially geovalid records not identified to species
-- with non-null country and null state_province
-- 2316057
select count(*) from view_full_occurrence_individual
where scrubbed_species_binomial IS NULL 
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country is not null AND state_province is null
;

-- highest counts of observation for potentially geovalid records
-- ignoring species binomial
SELECT country, count(*) as records
from view_full_occurrence_individual
where latitude IS NOT NULL AND longitude IS NOT NULL
AND country is not null
group by country
order by count(*) desc
limit 12
;
--  United States | 39857341
--   Netherlands   |  8474661
--   Spain         |  3576736
--   Norway        |  3506045
--   Denmark       |  1890785
--   Brazil        |  1833421
--   Australia     |  1300856
--   South Africa  |  1068237
--   Bolivia       |  1055606



-- Total potentially geovalid records not identified to species
-- with non-null country and non-null state_province
-- 2158851
select count(*) from view_full_occurrence_individual
where scrubbed_species_binomial IS NULL 
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country is not null AND state_province is not null
;
