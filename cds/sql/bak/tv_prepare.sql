-- ---------------------------------------------------------
-- Pre-process submitted name prior to submission to TNRS
-- 
-- These are all issues handled poorly by TNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS xxx;
CREATE INDEX name_submitted_name_submitted_idx ON name_submitted (name_submitted);

-- Remove multiple embedded spaces
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'   ',' ')
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'   ',' ')
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'  ',' ')
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'  ',' ')
;

-- Inserting following space after periods...";
-- Avoids adding space to numbered morphospecies
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'sp.','@@@')
WHERE name_submitted LIKE '%sp.%'
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'.','. ')
WHERE name_submitted LIKE '%.%'
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'  ',' ')
WHERE name_submitted LIKE '%  %'
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'  ',' ')
WHERE name_submitted LIKE '%  %'
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'@@@','sp.')
WHERE name_submitted LIKE '%@@@%'
;

-- Removing Fabaceae subfamilies...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE 'Fabaceae-caesalpinioideae%' THEN REPLACE(name_submitted,'-caesalpinioideae','')
WHEN name_submitted LIKE 'Fabaceae-mimosoideae%' THEN REPLACE(name_submitted,'-mimosoideae','')
WHEN name_submitted LIKE 'Fabaceae-papilionoideae%' THEN REPLACE(name_submitted,'-papilionoideae','')
ELSE name_submitted
END
;

-- Removing 'NA' authorities...";
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,' NA','')
WHERE name_submitted LIKE '% NA' 
;

-- Fixing '.var.'...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%.var.%' THEN REPLACE(name_submitted,'.var.',' var. ')
WHEN name_submitted LIKE '%.v.%' THEN REPLACE(name_submitted,'.v.',' var. ')
ELSE name_submitted
END
;

-- Fixing 'ss:'...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%ss:%' THEN REPLACE(name_submitted,'ss:','subsp. ')
ELSE name_submitted
END
;

-- Standardizing 'cfr.' to 'cf.'...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '% cfr.%' THEN REPLACE(name_submitted,'cfr.',' cf. ')
ELSE name_submitted
END
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'.aff',' aff.')
WHERE name_submitted LIKE '%.aff%' 
;

-- Setting 'species' to 'sp.'...";
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'species','sp.')
WHERE name_submitted LIKE '%species%'
;

-- Standardizing 'sp. nov.'...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%sp.nov.%' THEN REPLACE(name_submitted,'sp.nov.','sp. nov.')
WHEN name_submitted LIKE '%sp nov.%' THEN REPLACE(name_submitted,'sp nov.','sp. nov.')
WHEN name_submitted LIKE '%sp. nov %' THEN REPLACE(name_submitted,'sp. nov ','sp. nov. ')
ELSE name_submitted
END
;

-- Changing 'unidentified' to 'sp.'...";
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'unidentified','sp.')
WHERE name_submitted LIKE '%unidentified%'
;
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'Unidentified','sp.')
WHERE name_submitted LIKE '%Unidentified%'
;

-- Changing '&.' to '&'...";
UPDATE name_submitted
SET name_submitted=REPLACE(name_submitted,'&.','&')
WHERE name_submitted LIKE '%&.%'
;

-- Custome errors not handled by TNRS...";
UPDATE name_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%gLaucescens%' THEN REPLACE(name_submitted,'gLaucescens','glaucescens')
WHEN name_submitted LIKE '%mayumbensis.%' THEN REPLACE(name_submitted,'mayumbensis.','mayumbensis')
WHEN name_submitted LIKE '%subsp. Berchemioides%' THEN REPLACE(name_submitted,'Berchemioides','berchemioides')
WHEN name_submitted LIKE '%spp. canadensis%' THEN REPLACE(name_submitted,'spp.','subsp.')
WHEN name_submitted='Dipteryx magnifica Ducke (Ducke)' THEN 'Dipteryx magnifica Ducke'
WHEN name_submitted='Licania splendens (Korth. & sine ref.) Prance & Kosterm.' THEN 'Licania splendens (Korth.) Prance & Kosterm.'
WHEN name_submitted='Shorea cf. parvifolia f. Pahang' THEN 'Shorea cf. parvifolia fo. pahang'
WHEN name_submitted='Swintonia schwenkii eijsm. & Binn.' THEN 'Swintonia schwenkii Teijsm. & Binn.'
WHEN name_submitted LIKE 'Actinidia latifnlia (Gardn%' THEN 'Actinidia latifolia (Gardner & Champ.) Merr.'
WHEN name_submitted='Ocotea jorge-escobarii C. Nelson' THEN 'Ocotea jorge-escobarii Nelson'
WHEN name_submitted='Xanthophyllum papuanum Whitmore ex van derMeijden' THEN 'Xanthophyllum papuanum Whitmore ex van der Meijden'
WHEN name_submitted='Baccaurea sp. nov.? aff. macrophylla (Muell. Arg.) Muell. Arg.' THEN 'Baccaurea sp. nov.? [aff. macrophylla (Muell. Arg.) Muell. Arg.]'
WHEN name_submitted='Baccaurea sp. nov. ? aff. macrophylla (Muell. Arg. ) Muell. Arg' THEN 'Baccaurea sp. nov.? [aff. macrophylla (Muell. Arg.) Muell. Arg.]'
WHEN name_submitted='Pouteria sclerocarpa. aff' THEN 'Pouteria aff. sclerocarpa'
WHEN name_submitted='Litsea umbellata. v. fuscotomentosum' THEN 'Litsea umbellata var. fuscotomentosum'
WHEN name_submitted LIKE 'Gonzalagunia % hirsuta (Jacq.%' THEN 'Gonzalagunia hirsuta (Jacq.) K. Schum.'
WHEN name_submitted='Gonzalagunia Â hirsuta (Jacq. ) K. Schum.' THEN 'Gonzalagunia hirsuta (Jacq.) K. Schum.'
WHEN name_submitted LIKE '%. subsp.%' THEN REPLACE(name_submitted,'. subsp.',' subsp.')
WHEN name_submitted LIKE '%. var.%' THEN REPLACE(name_submitted,'. var.',' var.')
WHEN name_submitted LIKE '%. forma %' THEN REPLACE(name_submitted,'. forma ',' forma ')
WHEN name_submitted LIKE 'Ficus ???%' THEN 'Ficus sp.'
WHEN name_submitted LIKE 'Lagerstroemia ???%' THEN 'Lagerstroemia sp.'
WHEN name_submitted LIKE 'Memecylon ???%' THEN 'Memecylon sp.'
WHEN name_submitted='Viburnum nudum' THEN 'Viburnum nudum L.'
WHEN name_submitted='Psychotria aff. Calva Hiern' THEN 'Psychotria aff. calva Hiern'
WHEN name_submitted='Strychnos Cathayensis Merr.' THEN 'Strychnos cathayensis Merr.'
WHEN name_submitted='Phyllanthus Diandrus Pax' THEN 'Phyllanthus diandrus Pax'
ELSE name_submitted
END
;
