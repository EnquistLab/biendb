select country, state_province, is_in_country, is_in_state_province, is_in_county, is_geovalid, is_geovalid_issue 
from analytical_stem 
where country='Puerto Rico' 
limit 12;

select country, state_province, a.is_in_country, b.is_in_country, a.is_in_state_province, b.is_in_state_province, a.is_in_county, b.is_in_county, a.is_geovalid, b.is_geovalid as is_geovalid_bak, a.is_geovalid_issue 
from analytical_stem a JOIN astem_geovalid_bak b
ON a.analytical_stem_id=b.analytical_stem_id
where country='Puerto Rico' 
limit 12;


select country, state_province, a.is_in_country, b.is_in_country, a.is_in_state_province, b.is_in_state_province, a.is_in_county, b.is_in_county, a.is_geovalid, b.is_geovalid as is_geovalid_bak, a.is_geovalid_issue 
from view_full_occurrence_individual a JOIN vfoi_geovalid_bak b
ON a.taxonobservation_id=b.taxonobservation_id
where country='Puerto Rico' 
limit 12;

select country, state_province, a.is_in_country, b.is_in_country, a.is_in_state_province, b.is_in_state_province, a.is_in_county, b.is_in_county, a.is_geovalid, b.is_geovalid as is_geovalid_bak, a.is_geovalid_issue 
from view_full_occurrence_individual a JOIN vfoi_geovalid_bak b
ON a.taxonobservation_id=b.taxonobservation_id
where a.is_geovalid IS NOT NULL AND b.is_geovalid IS NULL
limit 12;

select country, state_province, a.is_in_country, b.is_in_country, a.is_in_state_province, b.is_in_state_province, a.is_in_county, b.is_in_county, a.is_geovalid, b.is_geovalid as is_geovalid_bak, a.is_geovalid_issue 
from view_full_occurrence_individual a JOIN vfoi_geovalid_bak b
ON a.taxonobservation_id=b.taxonobservation_id
where a.is_geovalid IS NULL AND b.is_geovalid IS NOT NULL
limit 12;

select distinct country, state_province, county 
from view_full_occurrence_individual 
where country is not null and is_geovalid is null 
order by country;

select count(*)
from view_full_occurrence_individual 
where country is not null and is_geovalid is null 
;