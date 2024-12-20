-- --------------------------------------------------------
-- Creates main traits table & raw trait data import table
-- --------------------------------------------------------

set search_path to :dev_schema;

-- Main trait table
DROP TABLE IF EXISTS agg_traits;
CREATE TABLE agg_traits (
id integer,
traits_id integer,
bien_taxonomy_id bigint,
fk_tnrs_id bigint,
verbatim_family text,
verbatim_scientific_name text,
name_submitted text,
family_matched text,
name_matched text,
name_matched_author text,
higher_plant_group text,
tnrs_warning text,
matched_taxonomic_status text,
scrubbed_taxonomic_status text,
scrubbed_family text,
scrubbed_genus text,
scrubbed_specific_epithet text,
scrubbed_species_binomial text,
scrubbed_taxon_name_no_author text,
scrubbed_taxon_canonical text,
scrubbed_author text,
scrubbed_taxon_name_with_author text,
scrubbed_species_binomial_with_morphospecies text,
trait_name text,
trait_value text,
unit text,
"method" text,
region text,
country_verbatim text,
state_province_verbatim text,
county_verbatim text,
country text,
state_province text,
lower_political text,
is_centroid smallint,
is_in_country smallint,
is_in_state_province smallint,
is_in_county smallint,
locality_description text,
latlong_verbatim text,
latitude text,
min_latitude text,
max_latitude text,
longitude text,
min_longitude text,
max_longitude text,
is_geovalid smallint,
is_new_world smallint,
elevation_verbatim text,
elevation_m integer,
elevation_min_m integer,
elevation_max_m integer,
source text,
url_source text,
source_citation text,
source_id text,
visiting_date date,
visiting_date_accuracy text,
reference_number text,
access text,
project_pi text,
project_pi_contact text,
observation text,
authorship text,
authorship_contact text,
citation_bibtex text,
plant_trait_files text,
is_experiment smallint,
observation_context text,
observation_date date,
observation_date_accuracy text,
source_locality text,
is_individual_trait smallint,
is_species_trait smallint,
is_trait_value_valid smallint,
temporary_taxonobservation_id text,
taxonobservation_id bigint,
is_individual_measurement smallint
);

-- Raw trait data table
DROP TABLE IF EXISTS traits_raw;
CREATE TABLE traits_raw (
"id" text default null,
"traits_id" text default null,
"verbatim_family" text default null,
"verbatim_scientific_name" text default null,
"name_submitted" text default null,
"family_matched" text default null,
"name_matched" text default null,
"name_matched_author" text default null,
"higher_plant_group" text default null,
"tnrs_warning" text default null,
"matched_taxonomic_status" text default null,
"scrubbed_taxonomic_status" text default null,
"scrubbed_family" text default null,
"scrubbed_genus" text default null,
"scrubbed_specific_epithet" text default null,
"scrubbed_species_binomial" text default null,
"scrubbed_taxon_name_no_author" text default null,
"scrubbed_taxon_canonical" text default null,
"scrubbed_author" text default null,
"scrubbed_taxon_name_with_author" text default null,
"scrubbed_species_binomial_with_morphospecies" text default null,
"trait_name" text default null,
"trait_value" text default null,
"unit" text default null,
"method" text default null,
"region" text default null,
"country" text default null,
"state_province" text default null,
"lower_political" text default null,
"locality_description" text default null,
"latitude" text default null,
"min_latitude" text default null,
"max_latitude" text default null,
"longitude" text default null,
"min_longitude" text default null,
"max_longitude" text default null,
"elevation_m" text default null,
"source" text default null,
"url_source" text default null,
"source_citation" text default null,
"source_id" text default null,
"visiting_date" text default null,
"reference_number" text default null,
"access" text default null,
"project_pi" text default null,
"project_pi_contact" text default null,
"observation" text default null,
"authorship" text default null,
"authorship_contact" text default null,
"citation_bibtex" text default null,
"plant_trait_files" text default null,
"fk_tnrs_user_id" text default null,
"is_experiment" text default null,
"observation_context" text default null,
"observation_date" text default null,
"source_locality" text default null,
"is_individual_trait" text default null,
"is_species_trait" text default null,
"is_trait_value_valid" text default null,
"temporary_taxonobservation_id" text default null,
"taxonobservation_id" text default null,
"is_individual_measurement" text default null
);