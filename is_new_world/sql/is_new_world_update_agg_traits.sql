-- ---------------------------------------------------------
-- Populates column is_new_world
-- Assumes political division names previously standardized 
-- using the GNRS
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

UPDATE agg_traits
SET 
is_new_world=
CASE 
WHEN state_province='Hawaii' THEN 0
WHEN country IS NULL THEN NULL
WHEN country IN (
'Anguilla',
'Antigua and Barbuda',
'Argentina',
'Aruba',
'Bahamas',
'Barbados',
'Belize',
'Bermuda',
'Bolivia',
'Bonaire, Saint Eustatius and Saba',
'Brazil',
'British Virgin Islands',
'Canada',
'Cayman Islands',
'Chile',
'Colombia',
'Costa Rica',
'Cuba',
'Curacao',
'Dominica',
'Dominican Republic',
'Ecuador',
'El Salvador',
'French Guiana',
'Greenland',
'Grenada',
'Guadeloupe',
'Guatemala',
'Guyana',
'Haiti',
'Honduras',
'Jamaica',
'Mexico',
'Montserrat',
'Nicaragua',
'Panama',
'Paraguay',
'Peru',
'Puerto Rico',
'Saint Barthelemy',
'Saint Kitts and Nevis',
'Saint Lucia',
'Saint Martin',
'Saint Pierre and Miquelon',
'Saint Vincent and the Grenadines',
'Sint Maarten',
'Suriname',
'Trinidad and Tobago',
'Turks and Caicos Islands',
'Uruguay',
'U.S. Virgin Islands',
'United States',
'Venezuela'
) THEN 1
ELSE 0
END
;

COMMIT;