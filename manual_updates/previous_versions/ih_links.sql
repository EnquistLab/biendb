-- 
-- Updates url structure in table "ih" to new format
-- 

\c vegbien
set search_path to analytical_db_dev;

ALTER TABLE ih ADD COLUMN url_old TEXT DEFAULT NULL;
UPDATE ih SET url_old="*url";

UPDATE ih
SET "*url"=REPLACE("*url",'ih/','ih/herbarium_details.php')
;

\c public_vegbien
set search_path to analytical_db_dev;

ALTER TABLE ih ADD COLUMN url_old TEXT DEFAULT NULL;
UPDATE ih SET url_old="*url";

UPDATE ih
SET "*url"=REPLACE("*url",'ih/','ih/herbarium_details.php')
;
