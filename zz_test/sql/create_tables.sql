-- ----------------------------------------------------------
-- Table set-up for zz_test. Run manually!
-- ----------------------------------------------------------

-- Run logged in as postgres
\c vegbien
set search_path to analytical_db_dev2;
drop table if exists owned_by_postgres;
create table owned_by_postgres (like analytical_db_dev.bien_metadata);
insert into owned_by_postgres select * from analytical_db_dev.bien_metadata;

-- Run logged in as bien
set search_path to analytical_db_dev2;
drop table if exists owned_by_bien;
create table owned_by_bien (like analytical_db_dev.bien_metadata);
insert into owned_by_bien select * from analytical_db_dev.bien_metadata;
