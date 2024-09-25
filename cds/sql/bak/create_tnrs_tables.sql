-- ---------------------------------------------------------
-- Creates tnrs results tables from parsing and scrubbing of
-- endangered taxon names
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS name_submitted;
CREATE TABLE name_submitted (
user_id bigserial not null,
name_submitted_verbatim text,
name_submitted text
);

DROP TABLE IF EXISTS name_parsed;
CREATE TABLE name_parsed (
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

DROP TABLE IF EXISTS name_scrubbed;
CREATE TABLE name_scrubbed (
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

