-- --------------------------------------------------------------------
-- Update FK plot_metadata_id in view_full_occurrence_individual_dev
-- --------------------------------------------------------------------

SET search_path TO :sch;



-- Fix vfoi
UPDATE view_full_occurrence_individual_dev a
SET country_verbatim=
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
AND (country_verbatim IS NULL OR TRIM(country_verbatim)='')
;

-- Fix plot_metadata
DROP TABLE IF EXISTS team_plot_countries_temp;
CREATE TABLE team_plot_countries_temp AS
SELECT plot_metadata_id, country_verbatim
FROM view_full_occurrence_individual_dev
WHERE datasource='TEAM'
;
DROP TABLE IF EXISTS team_plot_countries_unique_temp;
CREATE TABLE team_plot_countries_unique_temp AS
SELECT DISTINCT * FROM team_plot_countries_temp;
CREATE INDEX ON team_plot_countries_unique_temp (plot_metadata_id);

UPDATE plot_metadata a
SET country_verbatim=b.country_verbatim
FROM team_plot_countries_unique_temp b
WHERE a.plot_metadata_id=b.plot_metadata_id
;

DROP TABLE team_plot_countries_temp;
DROP TABLE team_plot_countries_unique_temp;
