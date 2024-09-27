-- 
-- Populates plot data provenance columns for datasource='VegBank'
-- 

SET search_path TO :dev_schema;

-- Transfer projects and data owner codes
UPDATE plot_provenance AS a
SET 
dataset=b.project_name,
primary_dataowner=b.project_pi,
primary_dataowner_email=b.email
FROM (
SELECT DISTINCT "locationName" AS plotcode, 
"projectName" AS project_name, 
TRIM(INITCAP(COALESCE(givenname,'')) || ' ' || INITCAP(COALESCE(surname,'')))
AS project_pi,
email
FROM 
"VegBank".plot AS a JOIN "VegBank".observation AS b ON a."locationID"=b.plot_id
JOIN "VegBank".project c ON b.project_id=c."projectID"
LEFT JOIN "VegBank".projectcontributor d ON c."projectID"=d.project_id
LEFT JOIN "VegBank".party e ON d.party_id=e.party_id
) AS b
WHERE a.datasource='VegBank'
AND a.plot_name=b.plotcode
;

-- Use observation contributor if no project contributor
-- PI only
UPDATE plot_provenance AS a
SET 
primary_dataowner=b.project_pi,
primary_dataowner_email=b.email
FROM (
SELECT DISTINCT "locationName" AS plotcode, 
TRIM(INITCAP(COALESCE(givenname,'')) || ' ' || INITCAP(COALESCE(surname,'')))
AS project_pi,
email
FROM 
"VegBank".plot AS a JOIN "VegBank".observation AS b ON a."locationID"=b.plot_id
LEFT JOIN "VegBank".observationcontributor c ON b.observation_id=c.observation_id
LEFT JOIN "VegBank".party d ON c.party_id=d.party_id
WHERE role_id=18
) AS b
WHERE a.datasource='VegBank'
AND a.plot_name=b.plotcode
AND (primary_dataowner IS NULL OR primary_dataowner='')
;

-- VegBank contact
UPDATE plot_provenance AS a
SET 
primary_dataowner=b.project_pi,
primary_dataowner_email=b.email
FROM (
SELECT DISTINCT "locationName" AS plotcode, 
TRIM(INITCAP(COALESCE(givenname,'')) || ' ' || INITCAP(COALESCE(surname,'')))
AS project_pi,
email
FROM 
"VegBank".plot AS a JOIN "VegBank".observation AS b ON a."locationID"=b.plot_id
LEFT JOIN "VegBank".observationcontributor c ON b.observation_id=c.observation_id
LEFT JOIN "VegBank".party d ON c.party_id=d.party_id
WHERE role_id=17
) AS b
WHERE a.datasource='VegBank'
AND a.plot_name=b.plotcode
AND (primary_dataowner IS NULL OR primary_dataowner='')
;

-- plot Author 
UPDATE plot_provenance AS a
SET 
primary_dataowner=b.project_pi,
primary_dataowner_email=b.email
FROM (
SELECT DISTINCT "locationName" AS plotcode, 
TRIM(INITCAP(COALESCE(givenname,'')) || ' ' || INITCAP(COALESCE(surname,'')))
AS project_pi,
email
FROM 
"VegBank".plot AS a JOIN "VegBank".observation AS b ON a."locationID"=b.plot_id
LEFT JOIN "VegBank".observationcontributor c ON b.observation_id=c.observation_id
LEFT JOIN "VegBank".party d ON c.party_id=d.party_id
WHERE role_id=6
) AS b
WHERE a.datasource='VegBank'
AND a.plot_name=b.plotcode
AND (primary_dataowner IS NULL OR primary_dataowner='')
;

-- Anyone other meaningful contributor 
UPDATE plot_provenance AS a
SET 
primary_dataowner=b.project_pi,
primary_dataowner_email=b.email
FROM (
SELECT DISTINCT "locationName" AS plotcode, 
TRIM(INITCAP(COALESCE(givenname,'')) || ' ' || INITCAP(COALESCE(surname,'')))
AS project_pi,
email
FROM 
"VegBank".plot AS a JOIN "VegBank".observation AS b ON a."locationID"=b.plot_id
LEFT JOIN "VegBank".observationcontributor c ON b.observation_id=c.observation_id
LEFT JOIN "VegBank".party d ON c.party_id=d.party_id
WHERE role_id NOT IN (34, 39, 40, 43, 44, 45, 46, 47, 48, 50, 51, 53, 54, 55)
) AS b
WHERE a.datasource='VegBank'
AND a.plot_name=b.plotcode
AND (primary_dataowner IS NULL OR primary_dataowner='')
;

-- Set emtpy strings to null
UPDATE plot_provenance AS a
SET primary_dataowner=NULL
WHERE primary_dataowner=''
;
