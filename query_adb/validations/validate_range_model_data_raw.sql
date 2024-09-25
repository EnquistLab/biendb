-- ------------------------------------------------------------------
-- Summary states for BIEN 4.2 range model data
-- ------------------------------------------------------------------

SELECT COUNT(*) AS total_observations
FROM range_model_data_raw;
/*
 total_observations 
--------------------
           66789249
(1 row)
*/

SELECT COUNT(DISTINCT scrubbed_species_binomial) AS total_species
FROM range_model_data_raw;
/*
 total_species 
---------------
        297762
(1 row)
*/

SELECT filter_group, 
COUNT(*) AS observations,
COUNT(DISTINCT scrubbed_species_binomial) AS species
FROM range_model_data_raw
GROUP BY filter_group
;
/*
 filter_group |  count   
--------------+----------
 common       | 23129750
 rare         | 43659499
(2 rows)
*/

SELECT higher_plant_group, 
COUNT(*) AS observations,
COUNT(DISTINCT b.scrubbed_species_binomial) AS species
FROM range_model_data_raw a JOIN range_model_data_metadata b
ON a.scrubbed_species_binomial=b.scrubbed_species_binomial
GROUP BY higher_plant_group
ORDER BY higher_plant_group
;
/*
    higher_plant_group     | observations | species 
---------------------------+--------------+---------
 bryophytes                |      5971468 |   15882
 ferns and allies          |      1699014 |   12875
 flowering plants          |     53439863 |  267874
 gymnosperms (conifers)    |      5650669 |     760
 gymnosperms (non-conifer) |        28235 |     371
(5 rows)
*/


SELECT '>=100' AS observations, COUNT(*) AS species
FROM range_model_data_metadata
WHERE observations>=100
UNION ALL 
SELECT '30-99' AS observations, COUNT(*) AS species
FROM range_model_data_metadata
WHERE observations<100 AND observations>=30
UNION ALL 
SELECT '10-29' AS observations, COUNT(*) AS species
FROM range_model_data_metadata
WHERE observations<30 AND observations>=10
UNION ALL 
SELECT '4-9' AS observations, COUNT(*) AS species
FROM range_model_data_metadata
WHERE observations<10 AND observations>=4
UNION ALL 
SELECT '1-3' AS observations, COUNT(*) AS species
FROM range_model_data_metadata
WHERE observations<4
;
/*
 observations | species 
--------------+---------
 >=100        |   54024
 30-99        |   49495
 10-29        |   57340
 4-9          |   51538
 1-3          |   85365
(5 rows)
*/

