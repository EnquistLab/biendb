-- ---------------------------------------------------------
-- Adds additional columns and indexes to table taxon_verbatim_parsed
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

CREATE INDEX ON taxon_verbatim_scrubbed (user_id);
