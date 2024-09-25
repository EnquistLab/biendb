-- ---------------------------------------------------------
-- Populates temp table observations_all
-- ---------------------------------------------------------

SET search_path TO :sch, postgis;

DROP TABLE IF EXISTS observations_all;

-- Note projection=3857 for geometry column
-- 4326 is alternative (WG@84)
SELECT scrubbed_species_binomial AS species, 
latitude, longitude, 
CAST(NULL AS geometry(Point,3857)) AS geom
INTO observations_all 
FROM :tbl_vfoi AS a, species AS b 
WHERE scrubbed_species_binomial = b.species AND (:sql_where_default) 
:limit
;