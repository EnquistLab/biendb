-- -----------------------------------------------------
-- Populates higher taxon columns in bien_taxonomy
-- 
-- Must be present in schema public_vegbien_dev in 
-- tnrs4 database. Assumes table higher_taxon has already
-- been created in same schema
-- -----------------------------------------------------

SET search_path TO :dev_schema;

-- Add temporary column for tracking updates
ALTER TABLE bien_taxonomy
ADD COLUMN "updated" INTEGER DEFAULT 0;

UPDATE bien_taxonomy
SET "scrubbed_taxon_name_no_author"=NULL
WHERE TRIM("scrubbed_taxon_name_no_author")='';
UPDATE bien_taxonomy
SET "scrubbed_author"=NULL
WHERE TRIM("scrubbed_author")='';

-- Join on taxon + author
-- Condition ht_count=1 not included because it
-- applied to taxon name alone, not taxon_author
UPDATE bien_taxonomy a
SET 
"order"=b."order",
"superorder"=b."superorder",
"subclass"=b."subclass",
"class"=b."class",
"division"=b."division",
updated=1
FROM higher_taxa b
WHERE a."scrubbed_taxon_name_no_author"=b."scientificName"
AND a."scrubbed_author"=b."scientificNameAuthorship"
;
-- Index column "updated" for use in following queries
CREATE INDEX bien_taxonomy_updated_idx on bien_taxonomy(updated);

-- Join on taxon without author
UPDATE bien_taxonomy a
SET 
"order"=b."order",
"superorder"=b."superorder",
"subclass"=b."subclass",
"class"=b."class",
"division"=b."division",
updated=1
FROM higher_taxa b
WHERE a."scrubbed_taxon_name_no_author"=b."scientificName"
AND a.updated=0
AND b.ht_count=1
;

-- Join on species
UPDATE bien_taxonomy a
SET 
"order"=b."order",
"superorder"=b."superorder",
"subclass"=b."subclass",
"class"=b."class",
"division"=b."division",
updated=1
FROM higher_taxa b
WHERE a."scrubbed_species_binomial"=b."scientificName"
AND a.updated=0
AND b.ht_count=1
;

-- Join on genus
UPDATE bien_taxonomy a
SET 
"order"=b."order",
"superorder"=b."superorder",
"subclass"=b."subclass",
"class"=b."class",
"division"=b."division",
updated=1
FROM higher_taxa b
WHERE a."scrubbed_genus"=b."scientificName"
AND a.updated=0
AND b.ht_count=1
;

-- Join on family
UPDATE bien_taxonomy a
SET 
"order"=b."order",
"superorder"=b."superorder",
"subclass"=b."subclass",
"class"=b."class",
"division"=b."division",
updated=1
FROM higher_taxa b
WHERE a."scrubbed_family"=b."scientificName"
AND a.updated=0
AND b.ht_count=1
;

-- Remove column "updated"; no longer needed
ALTER TABLE bien_taxonomy DROP COLUMN updated;

-- Replace empty strings with nulls, if any
UPDATE bien_taxonomy SET "order"=NULL where "order"='';
UPDATE bien_taxonomy SET "superorder"=NULL where "superorder"='';
UPDATE bien_taxonomy SET "subclass"=NULL where "subclass"='';
UPDATE bien_taxonomy SET "class"=NULL where "class"='';
UPDATE bien_taxonomy SET "division"=NULL where "division"='';

-- Create final indexes
DROP INDEX IF EXISTS bien_taxonomy_order_idx;
CREATE INDEX bien_taxonomy_order_idx on bien_taxonomy("order");

DROP INDEX IF EXISTS bien_taxonomy_superorder_idx;
CREATE INDEX bien_taxonomy_superorder_idx on bien_taxonomy("superorder");

DROP INDEX IF EXISTS bien_taxonomy_subclass_idx;
CREATE INDEX bien_taxonomy_subclass_idx on bien_taxonomy("subclass");

DROP INDEX IF EXISTS bien_taxonomy_class_idx;
CREATE INDEX bien_taxonomy_class_idx on bien_taxonomy("class");

DROP INDEX IF EXISTS bien_taxonomy_division_idx;
CREATE INDEX bien_taxonomy_division_idx on bien_taxonomy("division");
