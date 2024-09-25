-- ------------------------------------------------------------
-- Create species x query crosstab table
-- 
-- Requires parameters:
--	$sch --> :sch
-- ------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS species_observation_counts_sep_crosstab;
CREATE TABLE species_observation_counts_sep_crosstab AS
SELECT *
FROM public.crosstab(
   'SELECT species, filter, observations
    FROM   species_observation_counts_sep
    ORDER  BY 1,2'  -- could also just be "ORDER BY 1" here
, $$VALUES 
('1. Base filter'), 
('2. is_geovalid'),
('3. is_cultivated_observation'), 
('4. georef_protocol'), 
('5. is_centroid'), 
('6. year>=1970'), 
('7. is_introduced'), 
('8. observation_type')
$$
) AS ct (
"species" text, 
"1. Base filter" int, 
"2. is_geovalid" int,
"3. is_cultivated_observation" int,
"4. georef_protocol" int,
"5. is_centroid" int,
"6. year>=1970" int,
"7. is_introduced" int,
"8. observation_type" int
);

-- Set nulls to 0
UPDATE species_observation_counts_sep_crosstab
SET 
"2. is_geovalid"=
CASE WHEN "2. is_geovalid" IS NULL THEN 0 ELSE "2. is_geovalid" END,
"3. is_cultivated_observation"=
CASE WHEN "3. is_cultivated_observation" IS NULL THEN 0 ELSE "3. is_cultivated_observation" END,
"4. georef_protocol"=
CASE WHEN "4. georef_protocol" IS NULL THEN 0 ELSE "4. georef_protocol" END,
"5. is_centroid"=
CASE WHEN "5. is_centroid" IS NULL THEN 0 ELSE "5. is_centroid" END,
"6. year>=1970"=
CASE WHEN "6. year>=1970" IS NULL THEN 0 ELSE "6. year>=1970" END,
"7. is_introduced"=
CASE WHEN "7. is_introduced" IS NULL THEN 0 ELSE "7. is_introduced" END,
"8. observation_type"=
CASE WHEN "8. observation_type" IS NULL THEN 0 ELSE "8. observation_type" END
;
