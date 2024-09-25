-- ----------------------------------------------------------------
-- Populates missing families in table bien_taxonom
--
-- Assumes table genus_family (lookup of all TPL genus-in-family 
-- combos) already present in database
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- mop up majority of missing families
UPDATE bien_taxonomy AS a
SET scrubbed_family=b.family
FROM genus_family b
WHERE 
a.scrubbed_genus=b.genus AND 
a.scrubbed_family IS NULL
AND b."isAccepted"=1
;

--
-- mop up families of hybrid genera
--

-- create temporary column with genus minus the hybrid x
ALTER TABLE bien_taxonomy
ADD COLUMN genus_nohybrid CHAR(250) DEFAULT NULL
;
UPDATE bien_taxonomy
SET genus_nohybrid=REPLACE(scrubbed_genus,'x ','')
WHERE scrubbed_genus LIKE 'x %';
CREATE INDEX bien_taxonomy_genus_nohybrid_idx ON bien_taxonomy(genus_nohybrid);

-- Try again, this time joining on temporary column
UPDATE bien_taxonomy AS a
SET scrubbed_family=b.family
FROM genus_family b
WHERE 
a.genus_nohybrid=b.genus AND 
a.scrubbed_family IS NULL
AND b."isAccepted"=1
;

-- Remove temporary column
ALTER TABLE bien_taxonomy
DROP COLUMN genus_nohybrid;
