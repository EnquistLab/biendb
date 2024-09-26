-- ------------------------------------------------------------------
-- Rename schemas, archiving current versions and making dev version
-- current. This is the final step in new database release.
-- ------------------------------------------------------------------

\c vegbien

ALTER SCHEMA analytical_db RENAME TO analytical_db_4_1_1;
ALTER SCHEMA analytical_db_dev RENAME TO analytical_db;

-- Some tidying up
SET search_path TO analytical_db;
drop table species_observation_counts_sep_crosstab_bak;
drop table data_contributors_bak;
alter table data_contributors owner to bien;

\c public_vegbien
ALTER SCHEMA public RENAME TO public_4_1_1;
ALTER SCHEMA analytical_db_dev RENAME TO public;
-- Not sure about the next, but this was ownership of public
-- in BIEN 4.1.1
ALTER SCHEMA public OWNER TO postgres;

-- Some tidying up
SET search_path TO public;
drop table species_observation_counts_sep_crosstab_bak;
drop table data_contributors_bak;
alter table data_contributors owner to bien;
