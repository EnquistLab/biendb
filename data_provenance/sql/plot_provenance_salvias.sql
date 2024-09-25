-- 
-- Populates plot data provenance columns for datasource='SALVIAS'
-- 

SET search_path TO :dev_schema;

-- Transfer projects and data owner codes
UPDATE plot_provenance AS a
SET 
dataset=b.project_name,
primary_dataowner=b.project_pi
FROM (
SELECT "SiteCode", project_name, project_pi
FROM 
"SALVIAS"."plotMetadata" p JOIN "SALVIAS"."projects" pr
ON p.project_id=pr.project_id
) AS b
WHERE a.datasource='SALVIAS'
AND a.plot_name=b."SiteCode"
;

-- Expand data owner codes
UPDATE plot_provenance
SET primary_dataowner=
CASE
WHEN primary_dataowner='bboyle' THEN 'Brad Boyle'
WHEN primary_dataowner='mbonifacino' THEN 'Mauricio Bonifacino'
WHEN primary_dataowner='letcher' THEN 'Susan Letcher'
WHEN primary_dataowner='sdewalt' THEN 'Saara J. DeWalt'
WHEN primary_dataowner='cam_webb' THEN 'Cam Webb'
WHEN primary_dataowner='tkilleen' THEN 'Tim Killeen'
WHEN primary_dataowner='jsmiller' THEN 'James S. MIller'
WHEN primary_dataowner='oliverp' THEN 'Oliver Phillips'
ELSE NULL
END
WHERE datasource='SALVIAS';

UPDATE plot_provenance
SET dataset='Brad Boyle Forest Transects'
WHERE datasource='SALVIAS'
AND dataset='Boyle Transects'
;