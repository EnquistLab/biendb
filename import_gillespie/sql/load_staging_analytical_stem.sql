-- 
-- Load plot stem data to staging table
--

SET search_path TO :sch;

-- Note that null dbh values are inserted
-- these will be deleted in separate step
INSERT INTO analytical_stem_staging (
vfoi_staging_id,
datasource,
subplot,
individual_id,
individual_count,
stem_height_m,
cover_percent,
tag,
relative_x_m,
relative_y_m,
stem_code,
stem_dbh_cm
)
SELECT
vfoi_staging_id,
datasource,
a.subplot,
individual_id,
individual_count,
stem_height_m,
cover_percent,
NULL,
NULL,
NULL,
NULL,
case
when :"dbh_fld" is null or trim(:"dbh_fld")='' then null
when :"dbh_fld"::numeric>=1000 then null
else cast(:"dbh_fld" as numeric(5,1))
end
FROM vfoi_staging a JOIN :"tbl_raw" b
ON a.vfoi_staging_id=b.id
:limit
;