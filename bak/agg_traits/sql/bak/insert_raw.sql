-- --------------------------------------------------------
-- Insert raw data from traits_raw into agg_traits
-- --------------------------------------------------------

set search_path to :dev_schema;

-- Fix NAs in initial column
UPDATE traits_raw
SET family=NULL
WHERE family='NA'
;

INSERT INTO agg_traits (
traits_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
family_matched,
name_matched,
name_matched_author,
higher_plant_group,
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
"method",
region,
country,
stateprovince,
lower_political,
locality_description,
latitude,
longitude,
min_latitude,
max_latitude,
elevation,
"source",
url_source,
source_citation,
source_id,
visiting_date,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files
)
SELECT
cast(traits_id as integer),
family,
concat_ws(' ',
genus, species, intraspecific_rank, varsubsp, authority
),
CASE
WHEN family LIKE '%aceae' THEN
concat_ws(' ',
family, genus, species, intraspecific_rank, varsubsp, authority
)
ELSE concat_ws(' ',
genus, species, intraspecific_rank, varsubsp, authority
)
END,
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
stateprovince,
lower_political,
locality_description,
latitude,
longitude,
min_latitude,
max_latitude,
elevation,
"source",
url_source,
source_citation,
source_id,
visiting_date,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files
FROM traits_raw
;

-- Now index the field needed for next step

-- Add indexes needed for the following operations to agg_traits
CREATE INDEX agg_traits_id_idx ON agg_traits (id);
CREATE INDEX agg_traits_name_submitted_idx ON agg_traits (name_submitted);


