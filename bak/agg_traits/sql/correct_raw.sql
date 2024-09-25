-- --------------------------------------------------------
-- Correct known issues in raw data prior to submitting 
-- names to TNRS
-- --------------------------------------------------------

set search_path to :dev_schema;

-- Correct bad dates
-- Hard coded
UPDATE agg_traits
SET visiting_date=
case
when visiting_date='10-Jun-09' then '2009-06-10'
when visiting_date='20-Oct' then NULL
when visiting_date='20-Oct' then NULL
when visiting_date='22-May-09' then '2009-05-22'
when visiting_date='3-Nov-10' then '2010-11-03'
else visiting_date
end
;

-- Correct bad names
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Pentaphylacaeae ','')
WHERE name_submitted LIKE '%Pentaphylacaeae %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'cf.hirsuta','cf. hirsuta')
WHERE name_submitted LIKE '%cf.hirsuta%'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Pteridophyta ','')
WHERE name_submitted LIKE '%Pteridophyta %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Polemoniacea ','')
WHERE name_submitted LIKE '%Polemoniacea %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Lycopodiaccae ','')
WHERE name_submitted LIKE '%Lycopodiaccae %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Lacistematac ','')
WHERE name_submitted LIKE '%Lacistematac %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Elaeocarpace ','')
WHERE name_submitted LIKE '%Elaeocarpace %'
;
UPDATE agg_traits
SET name_submitted='Elaeodendron glaucum'
WHERE name_submitted LIKE '%Elaeodendron glaucum%'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Cypercceae ','')
WHERE name_submitted LIKE '%Cypercceae %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Lamiacaea/Labiatae ','')
WHERE name_submitted LIKE '%Lamiacaea/Labiatae %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Myrsi-ceae ','')
WHERE name_submitted LIKE '%Myrsi-ceae %'
;
UPDATE agg_traits
SET name_submitted=REPLACE(name_submitted,'Scrophulariacea ','')
WHERE name_submitted LIKE '%Scrophulariacea %'
;




