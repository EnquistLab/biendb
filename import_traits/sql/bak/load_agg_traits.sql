-- --------------------------------------------------------
-- Insert raw data from traits_raw into agg_traits
-- --------------------------------------------------------

set search_path to :dev_schema;

-- Method of inserting dates assumes that columns visiting_date and
-- observation_date have already been standardized to y-m-d format,
-- with 00 for day when day unknown and 00 for day and month when month
-- unknown
INSERT INTO agg_traits (
id,
traits_id,
bien_taxonomy_id,
fk_tnrs_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
family_matched,
name_matched,
name_matched_author,
higher_plant_group,
tnrs_warning,
matched_taxonomic_status,
scrubbed_taxonomic_status,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
trait_name,
trait_value,
unit,
method,
region,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
lower_political,
is_centroid,
is_in_country,
is_in_state_province,
is_in_county,
locality_description,
latlong_verbatim,
latitude,
min_latitude,
max_latitude,
longitude,
min_longitude,
max_longitude,
is_geovalid,
is_new_world,
elevation_verbatim,
elevation_m,
elevation_min_m,
elevation_max_m,
source,
url_source,
source_citation,
source_id,
visiting_date,
visiting_date_accuracy,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files,
is_experiment,
observation_context,
observation_date,
observation_date_accuracy,
source_locality,
is_individual_trait,
is_species_trait,
is_trait_value_valid,
temporary_taxonobservation_id,
taxonobservation_id,
is_individual_measurement
)
SELECT
cast(id as integer),
cast(traits_id as integer),
NULL,
NULL,
verbatim_family,
verbatim_scientific_name,
case
when verbatim_family like '%aceae' or verbatim_family in ('Compositae','Palmae','Gramineae','Cruciferae','Labiatae','Leguminosae','Guttiferae', 'Umbelliferae') then trim(concat_ws(' ',
verbatim_family, verbatim_scientific_name))
else trim(verbatim_scientific_name)
end,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
trait_name,
trait_value,
unit,
"method",
region,
country,
state_province,
lower_political,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
locality_description,
trim(concat_ws(' ',latitude, longitude)),
latitude,
min_latitude,
max_latitude,
longitude,
min_longitude,
max_longitude,
NULL,
NULL,
elevation_m,
case
when elevation_m='NA' or elevation_m=null or trim(elevation_m)='' THEN null
WHEN elevation_m LIKE '%-%' THEN CAST( 
round( ( (split_part(elevation_m,'-',1)::numeric + split_part(elevation_m,'-',2)::numeric) / 2 ), 0)
AS integer)
else cast(round(elevation_m::numeric,0) as integer)
end,
case
WHEN elevation_m LIKE '%-%' THEN round(split_part(elevation_m,'-',1)::numeric, 0)::integer
else NULL
end,
case
WHEN elevation_m LIKE '%-%' THEN round(split_part(elevation_m,'-',2)::numeric, 0)::integer
else NULL
end,
"source",
url_source,
source_citation,
source_id,
case 
when visiting_date is null then null
else cast(replace(visiting_date,'00','01') as date)
end,
case
when visiting_date is null then null
when split_part(visiting_date,'-',3)='0' then 'month'
when split_part(visiting_date,'-',2)='0' then 'year'
else 'day'
end,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files,
cast(is_experiment as smallint),
observation_context,
case 
when observation_date is null then null
else cast(replace(observation_date,'00','01') as date)
end,
case
when observation_date is null then null
when split_part(observation_date,'-',3)='0' then 'month'
when split_part(observation_date,'-',2)='0' then 'year'
else 'day'
end,
source_locality,
cast(is_individual_trait as smallint),
cast(is_species_trait as smallint),
cast(is_trait_value_valid as smallint),
temporary_taxonobservation_id,
cast(taxonobservation_id as bigint),
cast(is_individual_measurement as smallint)
FROM traits_raw
;

-- Now index the field needed for next step

-- Add indexes needed for the following operations to agg_traits
CREATE INDEX agg_traits_id_idx ON agg_traits (id);
CREATE INDEX agg_traits_name_submitted_idx ON agg_traits (name_submitted);


