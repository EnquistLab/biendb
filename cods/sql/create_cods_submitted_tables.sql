-- ---------------------------------------------------------
-- Create tables that hold data extract to be sent to CULTOBS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS cods_prox_submitted;
CREATE TABLE cods_prox_submitted (
latlong_text text,
latitude numeric,
longitude numeric
);


-- Joins descriptions back to original table
-- by primary key
-- id transferred to cods_desc_submitted
DROP TABLE IF EXISTS cods_desc_submitted_raw;
CREATE TABLE cods_desc_submitted_raw (
id serial primary key,
tbl_name text,
tbl_id bigint,
description text
);

DROP TABLE IF EXISTS cods_desc_submitted;
CREATE TABLE cods_desc_submitted (
id integer primary key,
description text
);
