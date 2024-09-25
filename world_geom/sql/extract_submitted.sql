-- ---------------------------------------------------------
-- Extract raw values for validation by pdf
-- ---------------------------------------------------------

SET search_path TO :sch;

INSERT INTO pdg_submitted (
id,
id_int,
country_verbatim,
state_province_verbatim,
county_verbatim,
geom
)
SELECT
:id_fld,
:id_fld,
country_verbatim,
state_province_verbatim,
county_verbatim,
geom
FROM :src_tbl
WHERE country_verbatim IS NOT NULL AND TRIM(country_verbatim)<>''
AND geom IS NOT NULL
;

