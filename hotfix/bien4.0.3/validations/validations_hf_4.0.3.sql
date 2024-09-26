-- ----------------------------------------------------------------
-- Test that corrections to FIA plot codes worked
-- In all cases, 't'=pass, 'f'=fail
-- ----------------------------------------------------------------

SET search_path TO analytical_db;

-- 
-- Queries on plot_metadata
-- 

-- Count plots found in >1 state
SELECT NOT EXISTS (
SELECT plot_name, COUNT(DISTINCT state_province)
FROM plot_metadata_dev
WHERE datasource='FIA'
GROUP BY plot_name
HAVING COUNT(DISTINCT state_province)>1
) AS "Plots in one state only"
; 

-- Count plots found in >1 county
SELECT NOT EXISTS (
SELECT plot_name, COUNT(DISTINCT CONCAT_WS(' ', state_province, county))
FROM plot_metadata_dev
WHERE datasource='FIA'
GROUP BY plot_name
HAVING COUNT(DISTINCT CONCAT_WS(' ', state_province, county))>1
) AS "Plots in one county only?"
;

-- Count plot codes with >1 row in plot_metadata
SELECT NOT EXISTS (
SELECT plot_name, COUNT(*) AS rows
FROM plot_metadata_dev
WHERE datasource='FIA'
GROUP BY plot_name
HAVING COUNT(*)>1
) AS "One row per plot code?"
;

-- Count plot codes with >1 unique value of latitude and longitude
SELECT NOT EXISTS (
SELECT plot_name, COUNT(DISTINCT CONCAT_WS(', ', latitude::text, longitude::text)) AS coordinates
FROM plot_metadata_dev
WHERE datasource='FIA'
GROUP BY plot_name
HAVING COUNT(DISTINCT CONCAT_WS(', ', latitude::text, longitude::text))>1
) AS "One set of coordinates per plot code?"
;

-- Count duplicate plot code & date records
SELECT NOT EXISTS (
SELECT plot_name, event_date, COUNT(*)
FROM plot_metadata_dev
WHERE datasource='FIA'
GROUP BY plot_name, event_date
HAVING COUNT(*)>1
) AS "No duplicate plot codes for same date?"
;

-- 
-- Queries on view_full_occurrence_individual
-- 

-- Count plots found in >1 state
SELECT NOT EXISTS (
SELECT plot_name, COUNT(DISTINCT state_province)
FROM vfoi_dev
WHERE observation_type='plot' AND datasource='FIA'
GROUP BY plot_name
HAVING COUNT(DISTINCT state_province)>1
) AS "Plots in one state only"
; 

-- Count plots found in >1 county
SELECT NOT EXISTS (
SELECT plot_name, COUNT(DISTINCT CONCAT_WS(' ', state_province, county))
FROM vfoi_dev
WHERE observation_type='plot' AND datasource='FIA'
GROUP BY plot_name
HAVING COUNT(DISTINCT CONCAT_WS(' ', state_province, county))>1
) AS "Plots in one county only?"
;


-- 
-- Additional validations that non-FIA sources not screwed up
-- 

-- Make sure all sources in original plot_metadata are present in new table
SELECT NOT EXISTS (
SELECT old.datasource, 'Missing original datasource' AS status
FROM 
( SELECT DISTINCT datasource FROM plot_metadata ) AS old
LEFT JOIN
( SELECT DISTINCT datasource FROM plot_metadata_dev ) AS new
ON old.datasource=new.datasource
WHERE new.datasource IS NULL
UNION ALL
SELECT new.datasource, 'New datasource not in original' AS status
FROM 
( SELECT DISTINCT datasource FROM plot_metadata ) AS old
RIGHT JOIN
( SELECT DISTINCT datasource FROM plot_metadata_dev ) AS new
ON old.datasource=new.datasource
WHERE old.datasource IS NULL
) AS "All datasources present"
;

-- Row counts same for all sources except FIA
SELECT NOT EXISTS (
SELECT old.datasource, old.rows AS old_rows, new.rows AS new_rows
FROM 
(
SELECT datasource, COUNT(*) AS rows
FROM plot_metadata
GROUP BY datasource
) AS old
JOIN 
(
SELECT datasource, COUNT(*) AS rows
FROM plot_metadata_dev
GROUP BY datasource
) AS new
ON old.datasource=new.datasource
WHERE old.datasource<>'FIA'
AND old.rows<>new.rows
) AS "Datasource row count unchanged"
;

-- Number of rows in vfoi unchanged
SELECT NOT EXISTS (
SELECT old.rows AS old_rows, new.rows AS new_rows 
FROM
( SELECT COUNT(*) AS rows FROM view_full_occurrence_individual ) AS old,
( SELECT COUNT(*) AS rows FROM view_full_occurrence_individual ) AS new
WHERE old.rows<>new.rows
) AS "vfoi rows unchanged"
;
