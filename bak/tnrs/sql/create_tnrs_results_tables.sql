-- ---------------------------------------------------------
-- Creates tnrs results tables from parsing and scrubbing of
-- endangered taxon names
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS tnrs_parsed;
CREATE TABLE tnrs_parsed (
name_submitted text,
taxon_name text,
canonical_name text,
author text,
family text,
genus text,
specific_epithet text,
infraspecific_rank text,
infraspecific_epithet text,
infraspecific_rank_2 text,
infraspecific_epithet_2 text,
annotations text,
unmatched_terms text
);

DROP TABLE IF EXISTS tnrs_scrubbed;
CREATE TABLE tnrs_scrubbed (
name_number integer,
name_submitted text,
overall_score text,
name_matched text,
name_matched_rank text,
name_score text,
name_matched_author text,
name_matched_url text,
author_matched text,
author_score text,
family_matched text,
family_score text,
name_matched_accepted_family text,
genus_matched text,
genus_score text,
specific_epithet_matched text,
specific_epithet_score text,
infraspecific_rank text,
infraspecific_epithet_matched text,
infraspecific_epithet_score text,
infraspecific_rank_2 text,
infraspecific_epithet_2_matched text,
infraspecific_epithet_2_score text,
annotations text,
unmatched_terms text,
taxonomic_status text,
accepted_name text,
accepted_name_author text,
accepted_name_rank text,
accepted_name_url text,
accepted_name_species text,
accepted_name_family text,
selected text,
source text,
warnings text,
accepted_name_lsid text
);   

-- Final TNRS results
-- Combines and interprets tnrs_parsed and tnrs_scrubbed
DROP TABLE IF EXISTS tnrs;
CREATE TABLE tnrs (
tnrs_id bigserial primary key,
name_submitted_verbatim text,
name_submitted text,
bien_taxonomy_id bigint,
taxon_id text,
family_taxon_id text,
genus_taxon_id text,
species_taxon_id text,
family_matched text,
name_matched text,
name_matched_author text,
tnrs_name_matched_score numeric,
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
sources text
);

