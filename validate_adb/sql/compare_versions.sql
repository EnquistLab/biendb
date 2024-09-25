-- ------------------------------------------------------------
-- Visually compare production and development databases
-- ------------------------------------------------------------

\c vegbien

-- 
-- Compare datasources
-- 

SELECT prod.obs AS "Total obs (production)", dev.obs as "Total obs (dev)"
FROM
(
SELECT COUNT(*) AS obs
FROM analytical_db.view_full_occurrence_individual
) AS prod,
(
SELECT COUNT(*) AS obs
FROM analytical_db_dev.view_full_occurrence_individual
) AS dev
;


-- 
-- Compare datasources
-- 

-- All sources in prod db, plus matching in dev
SELECT prod.datasource AS prod, prod.cnt AS prod_count,
dev.datasource AS dev, dev.cnt AS dev_count 
FROM
(
SELECT datasource, COUNT(*) AS cnt
FROM analytical_db.view_full_occurrence_individual
GROUP BY datasource
) AS prod
LEFT JOIN
(
SELECT datasource, COUNT(*) AS cnt
FROM analytical_db_dev.view_full_occurrence_individual
GROUP BY datasource
) AS dev
ON prod.datasource=dev.datasource
ORDER BY prod.datasource, dev.datasource
;

-- All sources in dev db, plus matching in prod
SELECT prod.datasource AS prod, prod.cnt AS prod_count,
dev.datasource AS dev, dev.cnt AS dev_count 
FROM
(
SELECT datasource, COUNT(*) AS cnt
FROM analytical_db.view_full_occurrence_individual
GROUP BY datasource
) AS prod
RIGHT JOIN
(
SELECT datasource, COUNT(*) AS cnt
FROM analytical_db_dev.view_full_occurrence_individual
GROUP BY datasource
) AS dev
ON prod.datasource=dev.datasource
ORDER BY prod.datasource, dev.datasource
;


