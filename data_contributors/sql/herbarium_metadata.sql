-- 
-- Populate additional metadata for herbarium providers
--

SET search_path TO :dev_schema;

-- Make sure all herbaria are flagged as such
UPDATE data_contributors
SET sourcetype='herbarium'
WHERE is_herbarium=1
;

-- Populate missing metadata for herbaria linked 
UPDATE data_contributors a
SET 
sourcetype='herbarium',
observationtype='specimen',
is_herbarium=1,
url_ih=ih."*url",
provider_name=
CASE
WHEN "*NamOrganisation" LIKE '%herbar%' THEN "*NamOrganisation"
ELSE TRIM(CONCAT_WS(' ',"*NamOrganisation", "*NamSection"))
END,
city=INITCAP(ih."*AddPhysCity"),
state_province=ih."*AddPhysState",
country=ih."*AddPhysCountry"
FROM ih
WHERE a.provider=ih.specimen_duplicate_institutions
;
-- Populate herbaria which are proximate providers
UPDATE data_contributors a
SET 
sourcetype='herbarium',
observationtype='specimen',
is_herbarium=1,
url_ih=ih."*url",
provider_name=
CASE
WHEN "*NamOrganisation" LIKE '%herbar%' THEN "*NamOrganisation"
ELSE TRIM(CONCAT_WS(' ',"*NamOrganisation", "*NamSection"))
END,
city=INITCAP(ih."*AddPhysCity"),
state_province=ih."*AddPhysState",
country=ih."*AddPhysCountry"
FROM ih
WHERE a.proximate_provider=ih.specimen_duplicate_institutions
;
