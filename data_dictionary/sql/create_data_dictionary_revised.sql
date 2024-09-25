-- ---------------------------------------------------------------------
-- Creates tables of revised content for updating data dictionary tables 
-- and materialized viewsdd_vals_revised
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Table names and comments
-- 

DROP TABLE IF EXISTS dd_tables_revised;
CREATE TABLE dd_tables_revised (
table_name text,
description text
)
;
CREATE INDEX ON dd_tables_revised (table_name);

-- 
-- Column names and comments
-- 

DROP TABLE IF EXISTS dd_cols_revised;
CREATE TABLE dd_cols_revised (
table_name text,
ordinal_position text,
column_name text,
data_type text,
can_be_null text,
description text
)
;

CREATE UNIQUE INDEX ON dd_cols_revised (table_name, column_name);
CREATE INDEX ON dd_cols_revised (column_name);


-- 
-- Column names and comments
-- 

-- Allowing nulls for column value allows maintaining all columns in 
-- master spreadsheet for filling out later.
DROP TABLE IF EXISTS dd_vals_revised;
CREATE TABLE dd_vals_revised (
table_name text not null,
column_name text not null,
"value" text default null,
definition text default null
)
;

CREATE INDEX ON dd_vals_revised (table_name, column_name, "value");
CREATE INDEX ON dd_vals_revised (column_name);
CREATE INDEX ON dd_vals_revised ("value");
