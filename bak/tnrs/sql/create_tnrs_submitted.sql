-- ---------------------------------------------------------
-- Creates tnrs results tables from parsing and scrubbing of
-- endangered taxon names
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS tnrs_submitted;
CREATE TABLE tnrs_submitted (
name_submitted_verbatim text,
name_submitted text
);

