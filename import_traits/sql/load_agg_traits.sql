-- --------------------------------------------------------
-- Insert raw data from traits_raw into agg_traits
-- --------------------------------------------------------

set search_path to :sch;

-- Method of inserting dates assumes that columns visiting_date and
-- observation_date have already been standardized to y-m-d format,
-- with 00 for day when day unknown and 00 for day and month when month
-- unknown
-- Note also that BIEN pipeline validation columns are not included
-- as these are populated after loading the raw data. Existing validation
-- values, if any, are not used. Not listing these columns gives more 
-- stability in case of schema changes to validation columns.
INSERT INTO agg_traits (
id_verbatim,
traits_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
trait_name,
trait_value,
unit,
method,
region,
country_verbatim,
state_province_verbatim,
county_verbatim,
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
visiting_date_verbatim,
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
observation_date_verbatim,
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
verbatim_family,
verbatim_scientific_name,
case
when verbatim_family like '%aceae' or verbatim_family in ('Compositae','Palmae','Gramineae','Cruciferae','Labiatae','Leguminosae','Guttiferae', 'Umbelliferae') then trim(concat_ws(' ',
verbatim_family, verbatim_scientific_name))
else trim(verbatim_scientific_name)
end,
trait_name,
trait_value,
unit,
"method",
region,
country,
state_province,
county,
locality_description,
trim(concat_ws(', ',latitude, longitude)),
case
when "latitude"='' then null
else cast("latitude" as numeric)
end,
case
when "min_latitude"='' then null
else cast("min_latitude" as numeric)
end,
case
when "max_latitude"='' then null
else cast("max_latitude" as numeric)
end,
case
when "longitude"='' then null
else cast("longitude" as numeric)
end,
case
when "min_longitude"='' then null
else cast("min_longitude" as numeric)
end,
case
when "max_longitude"='' then null
else cast("max_longitude" as numeric)
end,
NULL,
NULL,
elevation_m,
case
WHEN elev_mean=null THEN null
else CAST(round(elev_mean::numeric,0) as integer)
end,
case
WHEN elev_min=null THEN null
else CAST(round(elev_min::numeric,0) as integer)
end,
case
WHEN elev_max=null THEN null
else CAST(round(elev_max::numeric,0) as integer)
end,
"source",
url_source,
source_citation,
source_id,
visiting_date_verbatim,
case
when "vdate_yr" is null then NULL
when "vdate_yr" is not null and "vdate_mo" is null then cast(CONCAT_WS('-',"vdate_yr",'1','1') as date)
when "vdate_yr" is not null and "vdate_mo" is not null and "vdate_dy" is null then cast(CONCAT_WS('-',"vdate_yr","vdate_mo",'1') as date)
when "vdate_yr" is not null and "vdate_mo" is not null and "vdate_dy" is not null then cast(CONCAT_WS('-',"vdate_yr","vdate_mo","vdate_dy") as date)
else null
end,
case
when "vdate_yr" is not null and "vdate_mo" is null then 'year'
when "vdate_yr" is not null and "vdate_mo" is not null and "vdate_dy" is null then 'month'
when "vdate_yr" is not null and "vdate_mo" is not null and "vdate_dy" is not null then 'day'
else null
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
observation_date_verbatim,
case
when "obsdate_yr" is null then NULL
when "obsdate_yr" is not null and "obsdate_mo" is null then cast(CONCAT_WS('-',"obsdate_yr",'1','1') as date)
when "obsdate_yr" is not null and "obsdate_mo" is not null and "obsdate_dy" is null then cast(CONCAT_WS('-',"obsdate_yr","obsdate_mo",'1') as date)
when "obsdate_yr" is not null and "obsdate_mo" is not null and "obsdate_dy" is not null then cast(CONCAT_WS('-',"obsdate_yr","obsdate_mo","obsdate_dy") as date)
else null
end,
case
when "obsdate_yr" is not null and "obsdate_mo" is null then 'year'
when "obsdate_yr" is not null and "obsdate_mo" is not null and "obsdate_dy" is null then 'month'
when "obsdate_yr" is not null and "obsdate_mo" is not null and "obsdate_dy" is not null then 'day'
else null
end,
source_locality,
cast(is_individual_trait as smallint),
cast(is_species_trait as smallint),
cast(is_trait_value_valid as smallint),
temporary_taxonobservation_id,
cast(taxonobservation_id as bigint),
cast(is_individual_measurement as smallint)
FROM :tbl_raw
;

-- Now index the field needed for next step

-- Add indexes needed for the following operations to agg_traits
CREATE INDEX agg_traits_id_idx ON agg_traits (id);
CREATE INDEX agg_traits_name_submitted_idx ON agg_traits (name_submitted);


