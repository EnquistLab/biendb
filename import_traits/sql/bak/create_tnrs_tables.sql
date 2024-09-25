-- ---------------------------------------------------------
-- Creates tnrs results tables from parsing and scrubbing of
-- endangered taxon names
-- ---------------------------------------------------------

set search_path to :dev_schema;

DROP TABLE IF EXISTS taxon_verbatim_parsed;
CREATE TABLE taxon_verbatim_parsed (
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
unmatched_terms text,
user_id integer
);

DROP TABLE IF EXISTS taxon_verbatim_scrubbed;
CREATE TABLE taxon_verbatim_scrubbed (
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
accepted_name_lsid text,
user_id integer
);   

