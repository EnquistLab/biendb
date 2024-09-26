-- ----------------------------------------------------------------
-- Investigate impossible coordinates in geovalidation and centroids
-- validation exports
-- ----------------------------------------------------------------

\c vegbien
set search_path to analytical_db_dev;
drop table if exists ic_temp;
create table ic_temp (
tbl text,
id bigint,
country text,
state_province text,
county text,
latitude numeric,
longitude numeric
);

\copy ic_temp FROM '/home/boyle/bien3/repos/bien/analytical_db/private/manual_fixes/impossible_coordinates/impossible_coordinates.csv' CSV DELIMITER ',' HEADER  NULL 'NA';

drop index if exists ic_temp_tbl_idx;
drop index if exists ic_temp_id_idx;
drop index if exists ic_temp_country_idx;


create index ic_temp_tbl_idx on ic_temp (tbl);
create index ic_temp_id_idx on ic_temp (id);
create index ic_temp_country_idx on ic_temp (country);
