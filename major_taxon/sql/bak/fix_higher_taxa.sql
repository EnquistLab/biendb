-- -----------------------------------------------------
-- Misc fixes to higher_plant_group and higher taxon
-- columns
-- -----------------------------------------------------

SET search_path TO :dev_schema;

-- Remove erroneous bryophyte higher taxa
UPDATE bien_taxonomy
SET
"order"=NULL,
superorder=NULL,
subclass=NULL,
"class"=NULL,
division=NULL
WHERE higher_plant_group='bryophytes'
AND "class"='Equisetopsida';

-- Remove family & higher_plant_group from 
-- fungi wrongly classified by TNRS
UPDATE bien_taxonomy
SET scrubbed_family=NULL,
higher_plant_group=NULL
WHERE scrubbed_species_binomial IN (
'Collema crispum',
'Collema tenax',
'Lobaria pulmonaria',
'Lobaria retigera',
'Psora decipiens',
'Psora globifera',
'Psora nipponica',
'Psora pacifica',
'Psora russellii',
'Psora tuckermanii',
'Umbilicaria americana',
'Umbilicaria hyperborea',
'Umbilicaria krascheninnikovii',
'Umbilicaria phaea',
'Umbilicaria vellea',
'Umbilicaria virginis'
);

-- Populate family for above names
UPDATE bien_taxonomy
SET scrubbed_family=
CASE
WHEN scrubbed_genus='Collema' THEN 'Collemataceae'
WHEN scrubbed_genus='Psora' THEN 'Psoraceae'
WHEN scrubbed_genus='Lobaria' THEN 'Lobariaceae'
WHEN scrubbed_genus='Umbilicaria' THEN 'Umbilicariaceae'
ELSE scrubbed_family
END
WHERE division='Ascomycota'
;

-- Remove erroneous bryophyte higher taxa
UPDATE bien_taxonomy
SET
"order"='Cyatheales',
superorder=NULL,
subclass='Polypodiidae',
"class"='Equisetopsida',
division=NULL
WHERE scrubbed_species_binomial='Hemistegia insignis'
;

-- Mark the following homonym as illegitimate 
-- and correct wrong higher classification
UPDATE bien_taxonomy
SET
higher_plant_group='ferns and allies',
scrubbed_family='Gleicheniaceae',
scrubbed_taxonomic_status='illegitimate'
WHERE scrubbed_species_binomial='Mertensia crassifolia'
;