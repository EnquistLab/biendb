-- 
-- Populates plot data provenance columns for datasource='TEAM'
-- 

SET search_path TO :dev_schema;

-- Transfer projects and data owner codes
UPDATE plot_provenance AS a
SET 
dataset=b.project_name,
primary_dataowner=b.project_pi
FROM (
SELECT DISTINCT "1ha Plot Number" AS plotcode, 
"Site Name" AS project_name, 
"Data Set Contact" AS project_pi
FROM 
"TEAM"."VL" 
) AS b
WHERE a.datasource='TEAM'
AND a.plot_name=b.plotcode
;

UPDATE plot_provenance AS a
SET 
dataset=b.project_name,
primary_dataowner=b.project_pi
FROM (
SELECT DISTINCT "1ha Plot Number" AS plotcode, 
"Site Name" AS project_name, 
"Data Set Contact" AS project_pi
FROM 
"TEAM"."VT" 
) AS b
WHERE a.datasource='TEAM'
AND a.plot_name=b.plotcode
;