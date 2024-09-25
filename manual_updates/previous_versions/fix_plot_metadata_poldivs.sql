-- -------------------------------------------------------------------
-- Fill in missing political division info by querying vfoi
-- (temporary fix) 
-- Applied: 25 May 2018 to db version 4.0.1
-- 
-- Note: This does not fix missing political divisions in table vfoi!
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS pm_poldivs_temp1;
CREATE TABLE pm_poldivs_temp1 AS
SELECT 
plot_metadata_id,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world
FROM view_full_occurrence_individual
WHERE observation_type='plot'
;

DROP TABLE IF EXISTS pm_poldivs_temp2;
CREATE TABLE pm_poldivs_temp2 AS
SELECT DISTINCT * FROM pm_poldivs_temp1
;

-- Delete any mull values of the PK; not sure why these exists but they do
DELETE FROM pm_poldivs_temp2
WHERE plot_metadata_id IS NULL
;

-- Delete any non-updated duplicate records
DELETE FROM pm_poldivs_temp2
WHERE country_verbatim=''
;

-- Delete duplicated values with >1 set of political divisions
-- These are all FIA plots
DELETE FROM pm_poldivs_temp2 a 
USING (
SELECT plot_metadata_id, COUNT(*) 
FROM pm_poldivs_temp2 
GROUP BY plot_metadata_id 
HAVING COUNT(*)>1
) b
WHERE a.plot_metadata_id=b.plot_metadata_id
;

ALTER TABLE pm_poldivs_temp2 ADD PRIMARY KEY (plot_metadata_id);

UPDATE plot_metadata a
SET 
country_verbatim=b.country_verbatim,
state_province_verbatim=b.state_province_verbatim,
county_verbatim=b.county_verbatim,
country=b.country,
state_province=b.state_province,
county=b.county,
is_in_country=b.is_in_country,
is_in_state_province=b.is_in_state_province,
is_in_county=b.is_in_county,
is_geovalid=b.is_geovalid,
is_new_world=b.is_new_world
FROM pm_poldivs_temp2 b
WHERE a.plot_metadata_id=b.plot_metadata_id
;


-- Manually add country for selected sources
UPDATE plot_metadata
SET 
country_verbatim='United States',
country='United States',
is_geovalid=NULL,
is_new_world=1
WHERE datasource IN ('FIA', 'VegBank', 'CVS')
AND country_verbatim IS NULL OR country_verbatim=''
;
UPDATE plot_metadata
SET 
country_verbatim='New Zealand',
country='New Zealand',
is_geovalid=NULL,
is_new_world=0
WHERE datasource IN ('NVS')
AND country_verbatim IS NULL OR country_verbatim=''
;
UPDATE plot_metadata
SET 
country_verbatim='Bolivia',
country='Bolivia',
is_geovalid=NULL,
is_new_world=1
WHERE datasource IN ('Madidi')
AND country_verbatim IS NULL OR country_verbatim=''
;

-- TEAM, update by site name (=dataset)
UPDATE plot_metadata
SET 
country_verbatim=
CASE
WHEN dataset='Barro Colorado Nature Monument - Soberania National Park' THEN 'Panama'
WHEN dataset='Bukit Barisan' THEN 'Indonesia'
WHEN dataset='Bwindi Impenetrable Forest' THEN 'Uganda'
WHEN dataset='Caxiuanã' THEN 'Brazil'
WHEN dataset='Central Suriname Nature Reserve' THEN 'Suriname'
WHEN dataset='Cocha Cashu - Manu National Park' THEN 'Peru'
WHEN dataset='Korup National Park' THEN 'Cameroon'
WHEN dataset='Manaus' THEN 'Brazil'
WHEN dataset='Nam Kading' THEN 'Laos'
WHEN dataset='Nouabalé Ndoki' THEN 'Republic of Congo'
WHEN dataset='Pasoh Forest Reserve' THEN 'Malaysia'
WHEN dataset='Ranomafana' THEN 'Madagascar'
WHEN dataset='Udzungwa' THEN 'Tanzania'
WHEN dataset='Volcán Barva' THEN 'Costa Rica'
WHEN dataset='Yanachaga Chimillén National Park' THEN 'Peru'
WHEN dataset='Virunga Massif' THEN 'Rwanda'
WHEN dataset='Yasuni' THEN 'Ecuador'
ELSE country_verbatim
END
WHERE datasource='TEAM'
;
 
DROP TABLE IF EXISTS pm_poldivs_temp1;
DROP TABLE IF EXISTS pm_poldivs_temp2; 
