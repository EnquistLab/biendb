# GBIF Filtering in BIEN 4.2

## Raw GBIF data

Row counts by "basisOfRecord" in the raw GBIF data dump used for BIEN 4.2:

```
\c vegbien
SET search_path TO analytical_db_dev;

SELECT "basisOfRecord", count(*) 
FROM gbif_occurrence_raw 
GROUP BY "basisOfRecord" 
ORDER BY "basisOfRecord"
;
    basisOfRecord    |   count
---------------------+-----------
 FOSSIL_SPECIMEN     |    732257
 HUMAN_OBSERVATION   | 222825902
 LITERATURE          |    492181
 LIVING_SPECIMEN     |   1083428
 MACHINE_OBSERVATION |     77198
 MATERIAL_SAMPLE     |   1011800
 OBSERVATION         |   5558375
 PRESERVED_SPECIMEN  |  81193408
 UNKNOWN             |   9329322
(9 rows)
```

## Import to BIEN 4.2
The above are filtered and converted on import to BIEN observation\_type as follow:

```

INSERT INTO vfoi_staging (
observation_type,
[...]
SELECT
CASE
WHEN "basisOfRecord"='HUMAN_OBSERVATION' THEN 'human observation'
WHEN "basisOfRecord"='LITERATURE' THEN 'literature'
WHEN "basisOfRecord"='MATERIAL_SAMPLE' THEN 'material sample'
WHEN "basisOfRecord"='OBSERVATION' THEN 'unknown'
WHEN "basisOfRecord"='PRESERVED_SPECIMEN' THEN 'specimen'
WHEN "basisOfRecord" IS NULL THEN 'unknown'
ELSE 'unknown'
END,
[...]
FROM :"tbl_raw"
WHERE "basisOfRecord" NOT IN (
'FOSSIL_SPECIMEN',
'LIVING_SPECIMEN',
'MACHINE_OBSERVATION'
)
AND "institutionCode"<>'SIVIM'	-- Spanish herbarium full of centroids 
AND "institutionCode" NOT IN (	-- Primary sources excluded; see note below
'ARIZ',
'BRIT',
'HVAA',
'MO',
'NCU',
'NY',
'TEXv
'U',
'UNCC'
)
;
```

Note the list of herbaria NOT to include. These are sources imported directly to BIEN. However, direct imports for these sources are old. For BIEN 5.0 we either need to get new direct imports or remove them from this list and use the more recent GBIF data. See params.sh.

## GBIF data in BIEN 4.2

The above results in the following counts of observation_type for GBIF in BIEN 4.2:

```
SELECT observation_type, COUNT(*) as observations 
FROM view_full_occurrence_individual_dev 
WHERE datasource='GBIF' 
GROUP BY observation_type 
ORDER BY observation_type
;

observation_type  | observations
-------------------+--------------
human observation |    153551098
literature        |       492180
material sample   |       137133
specimen          |     65662268
unknown           |     14732054
(5 rows)
```

## Filtering by observation_type (range modeling)

The default WHERE clause for BIEN range modeling applies an additional filter on observation_type, as follows:

```
WHERE observation_type IN ('plot','specimen','literature','checklist')
```

 This has the effect of removing all remaining GBIF observations where "basisOfRecord" equals 'HUMAN\_OBSERVATION' or 'MATERIAL\_SAMPLE' or 'OBSERVATION' or 'UNKNOWN', in adddition to the records filtered on import.

## Summary

In BIEN 4.2, GBIF observations are filtered by basisOrRecord and/or observation_type as follows. Actual counts of observations in final column will be fewer than shown due to filters on other columns.

|   basisOfRecord    | observation_type |   Raw GBIF rows   |  BIEN 4.2 rows | Range modeling rows  
|   -------------- | ---------------- | ---------: | ------: | ------------:  
|    FOSSIL_SPECIMEN     | [not imported] |    732257 | 0 | 0  
|    HUMAN_OBSERVATION   | human observation |  222825902 | 153551098 | 0  
|    LITERATURE          | literature |     492181 | 492180 | 492180  
|    LIVING_SPECIMEN     | [not imported] |    1083428 | 0 | 0  
|    MACHINE_OBSERVATION | [not imported] |      77198 | 0 | 0  
|    MATERIAL_SAMPLE     | material sample |    1011800 | 137133 | 0  
|    OBSERVATION         | unknown |    5558375 | 0 | 0  
|    PRESERVED_SPECIMEN  | specimen |   81193408 | 65662268 | 65662268  
|    UNKNOWN             | unknown |    9329322 | 14732054 | 0  


