-- -----------------------------------------------------
-- Creates table of APG III higher taxa in schema 
-- public_vegbien_dev in  tnrs4 database
-- -----------------------------------------------------

SET search_path TO :dev_schema;

-- Create table and populate first higher taxon column (order)
DROP TABLE IF EXISTS higher_taxa;
CREATE table higher_taxa AS (
SELECT spp."nameID", spp."nameRank", 
spp."scientificName", spp."scientificNameAuthorship",
ht."scientificName" AS "order",
CAST(NULL AS VARCHAR(50)) AS "superorder",
CAST(NULL AS VARCHAR(50)) AS "subclass",
CAST(NULL AS VARCHAR(50)) AS "class",
CAST(NULL AS VARCHAR(50)) AS "division",
CAST(NULL AS VARCHAR(250)) AS "ht_index",
CAST(1 AS INTEGER) AS "ht_count"
FROM
(
SELECT n."nameID", n."nameRank", 
n."scientificName", n."scientificNameAuthorship",
c."leftIndex", c."rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE  c."sourceID"=4
AND n."nameRank" NOT IN (
'tribe',
'subtribe',
'subseries',
'series',
'suborder',
'order',
'superorder',
'subclass',
'class',
'kingdom'
)
) AS spp,
(
SELECT "nameRank", "scientificName", "leftIndex", "rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE "sourceID"=4
AND n."nameRank"='order'
) AS ht
WHERE spp."leftIndex">ht."leftIndex"
AND spp."rightIndex"<ht."rightIndex"
);

-- Create temporary table of superorders
DROP TABLE IF EXISTS "superorder";
CREATE table "superorder" AS (
SELECT spp."nameID",
ht."scientificName" AS "superorder"
FROM
(
SELECT n."nameID", n."nameRank", n."scientificName", c."leftIndex", c."rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE  c."sourceID"=4
AND n."nameRank" NOT IN (
'tribe',
'subtribe',
'subseries',
'series',
'suborder',
'order',
'superorder',
'subclass',
'class',
'kingdom'
)
) AS spp,
(
SELECT "nameRank", "scientificName", "leftIndex", "rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE "sourceID"=4
AND n."nameRank"='superorder'
) AS ht
WHERE spp."leftIndex">ht."leftIndex"
AND spp."rightIndex"<ht."rightIndex"
);

-- Create temporary table of subclasses
DROP TABLE IF EXISTS "subclass";
CREATE table "subclass" AS (
SELECT spp."nameID",
ht."scientificName" AS "subclass"
FROM
(
SELECT n."nameID", n."nameRank", n."scientificName", c."leftIndex", c."rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE  c."sourceID"=4
AND n."nameRank" NOT IN (
'tribe',
'subtribe',
'subseries',
'series',
'suborder',
'order',
'superorder',
'subclass',
'class',
'kingdom'
)
) AS spp,
(
SELECT "nameRank", "scientificName", "leftIndex", "rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE "sourceID"=4
AND n."nameRank"='subclass'
) AS ht
WHERE spp."leftIndex">ht."leftIndex"
AND spp."rightIndex"<ht."rightIndex"
);

-- Create temporary table of classes
DROP TABLE IF EXISTS "class";
CREATE table "class" AS (
SELECT spp."nameID",
ht."scientificName" AS "class"
FROM
(
SELECT n."nameID", n."nameRank", n."scientificName", c."leftIndex", c."rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE  c."sourceID"=4
AND n."nameRank" NOT IN (
'tribe',
'subtribe',
'subseries',
'series',
'suborder',
'order',
'superorder',
'subclass',
'class',
'kingdom'
)
) AS spp,
(
SELECT "nameRank", "scientificName", "leftIndex", "rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE "sourceID"=4
AND n."nameRank"='class'
) AS ht
WHERE spp."leftIndex">ht."leftIndex"
AND spp."rightIndex"<ht."rightIndex"
);

-- Create temporary table of divisions
DROP TABLE IF EXISTS "division";
CREATE table "division" AS (
SELECT spp."nameID",
ht."scientificName" AS "division"
FROM
(
SELECT n."nameID", n."nameRank", n."scientificName", c."leftIndex", c."rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE  c."sourceID"=4
AND n."nameRank" NOT IN (
'tribe',
'subtribe',
'subseries',
'series',
'suborder',
'order',
'superorder',
'subclass',
'class',
'kingdom'
)
) AS spp,
(
SELECT "nameRank", "scientificName", "leftIndex", "rightIndex"
FROM public.name n JOIN public.classification c
ON n."nameID"=c."nameID"
WHERE "sourceID"=4
AND n."nameRank"='division'
) AS ht
WHERE spp."leftIndex">ht."leftIndex"
AND spp."rightIndex"<ht."rightIndex"
);

-- Index the tables
CREATE INDEX higher_taxa_nameid_idx ON higher_taxa ("nameID");
CREATE INDEX superorder_nameid_idx ON "superorder" ("nameID");
CREATE INDEX subclass_nameid_idx ON "subclass" ("nameID");
CREATE INDEX class_nameid_idx ON "class" ("nameID");
CREATE INDEX division_nameid_idx ON "division" ("nameID");

-- Populate superorders
UPDATE higher_taxa a
SET "superorder"=b."superorder"
FROM "superorder" b
WHERE a."nameID"=b."nameID"
;

-- Populate subclasses
UPDATE higher_taxa a
SET "subclass"=b."subclass"
FROM "subclass" b
WHERE a."nameID"=b."nameID"
;

-- Populate classes
UPDATE higher_taxa a
SET "class"=b."class"
FROM "class" b
WHERE a."nameID"=b."nameID"
;

-- Populate divisions
UPDATE higher_taxa a
SET "division"=b."division"
FROM "division" b
WHERE a."nameID"=b."nameID"
;

-- Drop temporary tables
DROP TABLE IF EXISTS "superorder";
DROP TABLE IF EXISTS "subclass";
DROP TABLE IF EXISTS "class";
DROP TABLE IF EXISTS "division";

-- Fix nulls
UPDATE higher_taxa SET "order"=NULL WHERE "order"='';
UPDATE higher_taxa SET "superorder"=NULL WHERE "superorder"='';
UPDATE higher_taxa SET "subclass"=NULL WHERE "subclass"='';
UPDATE higher_taxa SET "class"=NULL WHERE "class"='';
UPDATE higher_taxa SET "division"=NULL WHERE "division"='';

-- Make table of names with >1 classification
UPDATE higher_taxa
set ht_index=concat_ws('@',
coalesce("order",''),
coalesce("superorder",''),
coalesce("subclass",''),
coalesce("class",''),
coalesce("division",'')
);

CREATE INDEX ht_index ON higher_taxa(ht_index);

DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 as (
SELECT DISTINCT "scientificName" AS name, ht_index
FROM higher_taxa 
);
CREATE INDEX  temp1_name_idx ON temp1(name);
CREATE INDEX  temp1_ht_index_idx ON temp1(ht_index);

DROP TABLE IF EXISTS multiple_higher_taxa;
CREATE TABLE multiple_higher_taxa AS (
SELECT name, COUNT(*) AS num_higher_taxa
FROM temp1
GROUP BY name
HAVING COUNT(*)>1
);

DROP TABLE temp1;
CREATE INDEX multiple_higher_taxa_name_idx on multiple_higher_taxa(name);
CREATE INDEX higher_taxa_scientificname_idx ON higher_taxa ("scientificName");

UPDATE higher_taxa a
SET ht_count=b.num_higher_taxa
FROM multiple_higher_taxa b
WHERE a."scientificName"=b.name
;
