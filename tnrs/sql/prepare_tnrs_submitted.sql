-- ---------------------------------------------------------
-- Pre-process submitted name prior to submission to TNRS
-- 
-- These are all issues handled poorly by TNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS tnrs_submitted_name_submitted_idx;
CREATE INDEX tnrs_submitted_name_submitted_idx ON tnrs_submitted (name_submitted);

-- Delete any name *not* beginning with a letter, double quotes or 
-- single quotes. These wreak havoc on the TNRS and are almost always crap
DELETE FROM tnrs_submitted
WHERE NOT name_submitted  ~* '^[a-zA-Z]' AND NOT name_submitted ~ '^\"' AND NOT name_submitted ~ '^'''
;

-- Remove embedded line endings of all kinds
-- This fixes everything, 'all-in-one'
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, E'[\\n\\r\\f\\u000A\\u000C\\u000D\\u000B\\u0085\\u2028\\u2029]+', ' ', 'g' )
WHERE name_submitted ~ E'[\\n\\r\\f\\u000A\\u000C\\u000D\\u000B\\u0085\\u2028\\u2029]+'
;

-- Trim possible hidden line endings from known bad names causing undiagnosed crash of TNRSbatch
UPDATE tnrs_submitted 
SET name_submitted='Lamiaceae Agastache pallidiflora (Heller) Rydb. spp. pallidiflora var. gilensis R.W. Sanders'
WHERE name_submitted LIKE '%Agastache pallidiflora (Heller) Rydb. spp. pallidiflora var. gilensis % Sanders%'
;
UPDATE tnrs_submitted 
SET name_submitted='Lamiaceae Agastache pallidiflora spp. neomexicana var. neomexicana'
WHERE name_submitted LIKE '%Agastache pallidiflora spp. neomexicana var. neomexicana%'
;


-- Replace multiple internal whitespace or tabs with single whitespace
-- and trim surrounding whitespace
UPDATE tnrs_submitted
SET name_submitted=trim(regexp_replace(name_submitted, '\s+', ' ', 'g'))
WHERE name_submitted LIKE ' %'
OR name_submitted LIKE '% '
OR name_submitted LIKE '%  %'
OR name_submitted LIKE '%'||chr(9)||'%'
;

-- Replace hybrid x with plain x
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'×','x')
WHERE name_submitted LIKE '%×%'
;

-- Inserting following space after periods...";
-- Avoids adding space to numbered morphospecies
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'sp.','@@@')
WHERE name_submitted LIKE '%sp.%'
;
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'.','. ')
WHERE name_submitted LIKE '%.%'
;
UPDATE tnrs_submitted
SET name_submitted=trim(regexp_replace(name_submitted, '\s+', ' ', 'g'))
WHERE name_submitted LIKE '%  %'
;
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'@@@','sp.')
WHERE name_submitted LIKE '%@@@%'
;

-- Removing Fabaceae subfamilies...";
UPDATE tnrs_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE 'Fabaceae-caesalpinioideae%' THEN REPLACE(name_submitted,'-caesalpinioideae','')
WHEN name_submitted LIKE 'Fabaceae-mimosoideae%' THEN REPLACE(name_submitted,'-mimosoideae','')
WHEN name_submitted LIKE 'Fabaceae-papilionoideae%' THEN REPLACE(name_submitted,'-papilionoideae','')
ELSE name_submitted
END
WHERE name_submitted LIKE 'Fabaceae-%'
;

-- Removing 'NA' authorities...";
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,' NA','')
WHERE name_submitted LIKE '% NA' 
;

-- Fixing '.var.'...";
UPDATE tnrs_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%.var.%' THEN REPLACE(name_submitted,'.var.',' var. ')
WHEN name_submitted LIKE '%.v.%' THEN REPLACE(name_submitted,'.v.',' var. ')
ELSE name_submitted
END
WHERE name_submitted LIKE '%.var.%' OR name_submitted LIKE '%.v.%' 
;

-- Fixing 'ss:'...";
UPDATE tnrs_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%ss:%' THEN REPLACE(name_submitted,'ss:','subsp. ')
ELSE name_submitted
END
WHERE name_submitted LIKE '%ss:%' 
;

-- Standardizing 'cfr.' to 'cf.'...";
UPDATE tnrs_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '% cfr.%' THEN REPLACE(name_submitted,'cfr.',' cf. ')
ELSE name_submitted
END
WHERE name_submitted LIKE '% cfr.%' 
;
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'.aff',' aff.')
WHERE name_submitted LIKE '%.aff%' 
;

-- Setting 'species' to 'sp.'...";
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'species','sp.')
WHERE name_submitted LIKE '%species%'
;

-- Standardizing 'sp. nov.'...";
UPDATE tnrs_submitted
SET name_submitted=
CASE
WHEN name_submitted LIKE '%sp.nov.%' THEN REPLACE(name_submitted,'sp.nov.','sp. nov.')
WHEN name_submitted LIKE '%sp nov.%' THEN REPLACE(name_submitted,'sp nov.','sp. nov.')
WHEN name_submitted LIKE '%sp. nov %' THEN REPLACE(name_submitted,'sp. nov ','sp. nov. ')
ELSE name_submitted
END
WHERE name_submitted LIKE '%sp.nov.%' 
OR name_submitted LIKE '%sp nov.%' 
OR name_submitted LIKE '%sp. nov %'
;

-- Changing 'unidentified' to 'sp.'...";
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'unidentified','sp.')
WHERE name_submitted LIKE '%unidentified%'
;
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'Unidentified','sp.')
WHERE name_submitted LIKE '%Unidentified%'
;

-- Changing '&.' to '&'...";
UPDATE tnrs_submitted
SET name_submitted=REPLACE(name_submitted,'&.','&')
WHERE name_submitted LIKE '%&.%'
;

-- Custom errors not handled by TNRS...";
UPDATE tnrs_submitted
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

-- Convert underscores to hyphen for names where underscores likely
-- link components of a morphospecies string
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, '[_]' , '-', 'g' )
WHERE name_submitted ~ '_'
AND name_submitted LIKE '%indet%'
;

-- Replace underscores in remaining names with single whitespace
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, '[_]' , ' ', 'g' )
WHERE name_submitted ~ '_'
;

-- IMPORTANT!
-- Replace commas with single whitespace to avoid know TNRS bug
UPDATE tnrs_submitted
SET name_submitted=trim(replace(name_submitted, ',', ' '))
WHERE name_submitted LIKE '%,%'
;

-- CRITICAL! Replace all pipes ("|") with whitespace
-- Must ensure no pipes in name because TNRSbatch uses pipe to 
-- distinguish ID from name in input file
UPDATE tnrs_submitted
SET name_submitted=trim(replace(name_submitted, '|', ' '))
WHERE name_submitted LIKE '%|%'
;

-- Replace multiple internal whitespace or tabs with single whitespace
-- and trim surrounding whitespace
-- Doing second time in case any result from preceding queries
UPDATE tnrs_submitted
SET name_submitted=trim(regexp_replace(name_submitted, '\s+', ' ', 'g'))
WHERE name_submitted LIKE ' %'
OR name_submitted LIKE '% '
OR name_submitted LIKE '%  %'
OR name_submitted LIKE '%'||chr(9)||'%'
;
