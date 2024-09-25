/* ------------------------------------------------------------------
Add table dataowner to accommodate multiple contributors per 
datasource or dataset.

Insert additional record for Stephanie Pau as contributor to
Gillespie Plots datasource/dataset

Date: 19 Nov. 2021
NOT YET ADDED TO BIEN DB PIPELINE
*/ ------------------------------------------------------------------

-- \c vegbien
-- set search_path to analytical_db;

-- DON'T FORGET TO RUN UPDATE ON PUBLIC DB AS WELL!

--
-- Create the table
--

DROP TABLE IF EXISTS dataowner;
CREATE TABLE dataowner (
dataowner_id SERIAL PRIMARY KEY,
datasource_id INTEGER NOT NULL,
dataowner_type TEXT NOT NULL,
is_primary_contact INTEGER NOT NULL DEFAULT 0,
first_name TEXT DEFAULT NULL,
middle_name TEXT DEFAULT NULL,
last_name TEXT DEFAULT NULL,
second_last_name TEXT DEFAULT NULL,
full_name TEXT DEFAULT NULL,
institution_name TEXT DEFAULT NULL,
department_name TEXT DEFAULT NULL,
job_title TEXT DEFAULT NULL,
email TEXT DEFAULT NULL,
email_other TEXT DEFAULT NULL,
url TEXT DEFAULT NULL,
address1 TEXT DEFAULT NULL,
address2 TEXT DEFAULT NULL,
city TEXT DEFAULT NULL,
state TEXT DEFAULT NULL,
country TEXT DEFAULT NULL,
postal_code TEXT DEFAULT NULL,
phone1 TEXT DEFAULT NULL,
phone2 TEXT DEFAULT NULL
);

-- Indexes
CREATE INDEX dataowner_datasource_id_idx ON dataowner(datasource_id);
CREATE INDEX dataowner_first_name_idx ON dataowner(first_name);
CREATE INDEX dataowner_last_name_idx ON dataowner(last_name);
CREATE INDEX dataowner_full_name_idx ON dataowner(full_name);
CREATE INDEX dataowner_institution_name_idx ON dataowner(institution_name);
CREATE INDEX dataowner_data_owner_type_idx ON dataowner(data_owner_type);

-- FK to table datasource
ALTER TABLE dataowner
ADD CONSTRAINT fk_dataowner_datasource FOREIGN KEY (datasource_id) REFERENCES datasource (datasource_id);

--
-- Add existing data owners from table datasource
--

INSERT INTO dataowner (
datasource_id,
dataowner_type,
is_primary_contact,
first_name,
last_name,
full_name,
institution_name,
email
) 
SELECT
datasource_id,
'institution',
1,
primary_contact_firstname,
primary_contact_lastname,
primary_contact_fullname,
primary_contact_institution_name,
primary_contact_email
FROM datasource
;

-- Figure out dataowner_type and update it
UPDATE dataowner
SET dataowner_type='person'
WHERE first_name IS NOT NULL AND last_name IS NOT NULL
;

-- Parse full names and reset dataowner_type
UPDATE dataowner
SET 
first_name=trim(split_part(full_name,' ', 1)),
last_name=trim(split_part(full_name,' ', 2)),
dataowner_type='person'
WHERE first_name IS NULL
AND full_name IS NOT NULL
AND institution_name IS NULL
AND full_name like '% %' AND full_name NOT LIKE '% % %'
;

-- Tag composite person entries, insert separately and delete composites
UPDATE dataowner
SET dataowner_type='composite'
WHERE full_name LIKE '%;%'
;
INSERT INTO dataowner (
datasource_id,
dataowner_type,
full_name,
is_primary_contact
) 
SELECT
datasource_id,
'newperson',
trim(split_part(full_name,';', 1)),
1
FROM dataowner
WHERE dataowner_type='composite'
;
INSERT INTO dataowner (
datasource_id,
dataowner_type,
full_name
) 
SELECT
datasource_id,
'newperson',
trim(split_part(full_name,';', 2))
FROM dataowner
WHERE dataowner_type='composite'
;
INSERT INTO dataowner (
datasource_id,
dataowner_type,
full_name
) 
SELECT
datasource_id,
'newperson',
trim(split_part(full_name,';', 3))
FROM dataowner
WHERE dataowner_type='composite'
AND full_name LIKE '%;%;%'
;
DELETE FROM dataowner
WHERE dataowner_type='composite'
;

--
-- Tidy up
-- 
UPDATE dataowner
SET 
first_name=trim(split_part(full_name,' ', 1)),
last_name=trim(split_part(full_name,' ', 2))
WHERE dataowner_type='newperson'
AND full_name like '% %' AND full_name NOT LIKE '% % %'
;
UPDATE dataowner
SET first_name='Mohammad Shahfiz',
last_name='Bin Azman'
WHERE dataowner_type='newperson'
AND full_name='Mohammad Shahfiz Bin Azman'
;
UPDATE dataowner
SET first_name='Sarah',
last_name='Bengbate'
WHERE dataowner_type='newperson'
AND full_name='Sarah Yoga Bengbate'
;
UPDATE dataowner
SET first_name='Jean',
middle_name='Claude',
last_name='Razafimahaimodison'
WHERE dataowner_type='newperson'
AND full_name='Jean Claude Razafimahaimodison'
;
UPDATE dataowner
SET first_name='Miriam',
last_name='van Heist'
WHERE dataowner_type='newperson'
AND full_name='Miriam van Heist'
;
DELETE FROM dataowner
WHERE full_name='Demo User'
;
UPDATE dataowner
SET dataowner_type='person'
WHERE dataowner_type='newperson'
;

--
-- Add new data owner for Gillespie plots
-- 

INSERT INTO dataowner (
datasource_id,
dataowner_type,
is_primary_contact,
first_name,
last_name,
full_name,
institution_name,
department_name,
email,
job_title
) 
VALUES (
408,
'person',
0,
'Stephanie',
'Pau',
'Stephanie Pau',
'Florida State University',
'Department of Geography',
'spau@fsu.edu',
'Associate Professor'
)
;